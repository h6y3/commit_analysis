#!/bin/bash

# Define the configuration file and output directory relative to this script's location
script_dir="$(dirname "$(realpath "$0")")"
config_file="${script_dir}/repo_paths.conf"
output_directory="${script_dir}/repo_commit_counts_by_author"

# Check if the configuration file exists
if [ ! -f "$config_file" ]; then
    echo "Configuration file not found: $config_file"
    exit 1
fi

# Create the output directory if it doesn't exist
if [ ! -d "$output_directory" ]; then
    mkdir -p "$output_directory"
fi

# Use a different file descriptor (3) to read from the config file
while IFS= read -r repo_path <&3; do
    # Check if the repository path exists
    if [ ! -d "$repo_path" ]; then
        echo "Repository path not found: $repo_path"
        continue
    fi

    # Extract the base name of the repository for the output file
    repo_name=$(basename "$repo_path")
    output_file="${output_directory}/repo_commit_counts_by_author_${repo_name}.csv"

    # Navigate to the repository
    pushd "$repo_path" > /dev/null

    # Write the CSV header
    echo "Author,Commit Count" > "$output_file"

    # Get the list of authors and their commit counts, using git shortlog
    git shortlog -sn --no-merges --since="1 year ago" | while read commit_count author; do
        # Append the data to the CSV file
        echo "\"$author\",$commit_count" >> "$output_file"
    done

    # Return to the original directory
    popd > /dev/null

    echo "Generated commit count report for $repo_name: $output_file"
# Redirect the config file into file descriptor 3
done 3< "$config_file"
