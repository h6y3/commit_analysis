#!/bin/bash

# Path to the configuration file containing repository paths
CONFIG_FILE="repo_paths.conf"

# Temporary file to aggregate commit counts
TEMP_FILE="$(mktemp)"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found: $CONFIG_FILE"
  exit 1
fi

# Read repository paths from the configuration file and collect commit stats from the last year
while IFS= read -r REPO_PATH || [[ -n "$REPO_PATH" ]]; do
  echo "Processing $REPO_PATH..."
  (cd "$REPO_PATH" && git log --since="1 year ago" --pretty='%aN' | sort | uniq -c | sort -nr) >> "$TEMP_FILE"
done < "$CONFIG_FILE"

# Aggregate commit counts across repositories and output to a CSV file
echo "Commit Count,Author" > aggregate_commits.csv
awk '{arr[$2]+=$1} END {for (i in arr) print arr[i] "," i}' "$TEMP_FILE" | sort -nr >> aggregate_commits.csv

# Clean up the temporary file
rm "$TEMP_FILE"

echo "Aggregated commit counts from the last year have been saved to aggregate_commits.csv"
