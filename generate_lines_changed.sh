#!/bin/bash

# Define the configuration file and output directory relative to this script's location
script_dir="$(dirname "$(realpath "$0")")"
config_file="${script_dir}/repo_paths.conf"
output_directory="${script_dir}/repo_lines_change_by_author"

# Check if the configuration file exists
if [ ! -f "$config_file" ]; then
    echo "Configuration file not found: $config_file"
    exit 1
fi

# Create the output directory if it doesn't exist
if [ ! -d "$output_directory" ]; then
    mkdir -p "$output_directory"
fi

# Read each repository path from the configuration file
while IFS= read -r repo_path
do
    # Check if the repository path exists
    if [ ! -d "$repo_path" ]; then
        echo "Repository path not found: $repo_path"
        continue
    fi

    # Extract the base name of the repository for the output file
    repo_name=$(basename "$repo_path")
    output_file="${output_directory}/repo_lines_changed_by_author_${repo_name}.csv"

    # Navigate to the repository
    pushd "$repo_path" > /dev/null

    # Write the CSV header
    echo "Author,Lines Added,Lines Removed,Net Lines Changed" > "$output_file"

    # Get the list of authors
    authors=$(git log --all --since="1 year ago" --no-merges --pretty="%an" | sort -u)

    # Loop through each author and summarize their changes
    while IFS= read -r author
    do
        # Use git log to calculate lines added, removed for the author
        read added removed <<< $(git log --author="$author" --since="1 year ago" --no-merges --pretty=tformat: --numstat | awk '{added += $1; removed += $2} END {print added, removed}')

        # Calculate net lines changed
        let net=added-removed

        # Append the data to the CSV file
        echo "\"$author\",$added,$removed,$net" >> "$output_file"
    done <<< "$authors"

    # Return to the original directory
    popd > /dev/null

    echo "Generated report for $repo_name: $output_file"
done < "$config_file"
