# Git Repository Analysis Scripts

This repository contains scripts designed to analyze Git repositories for team contributions over the last year, excluding merge commits. The scripts generate CSV reports that summarize lines of code changed, commit counts by author, and aggregate commit counts across all specified repositories.

## Overview

- `generate_lines_changed.sh`: Generates reports summarizing lines added, removed, and net changes by each author.
- `generate_commit_counts.sh`: Counts the number of commits made by each author.
- `aggregate_commits.sh`: Aggregates commit counts across all repositories and outputs the summary to a CSV file.

## Prerequisites

- Git
- Bash shell
- `awk` utility (usually pre-installed on Linux and macOS)

## Setup

1. Clone or download these scripts to your local machine.
2. Ensure the scripts are executable:
   ```bash
   chmod +x generate_lines_changed.sh generate_commit_counts.sh aggregate_commits.sh
   ```
3. Create a `repo_paths.conf` file in the same directory as the scripts. List the full path to each Git repository you wish to analyze, one per line.

## Usage

### Lines of Code Changed Report

1. Run `generate_lines_changed.sh` from the terminal:
   ```bash
   ./generate_lines_changed.sh
   ```
2. The script creates a directory named `repo_lines_change_by_author` and generates a CSV report for each repository listed in `repo_paths.conf`, summarizing the lines of code changed by each author.

### Commit Counts Report

1. Run `generate_commit_counts.sh` from the terminal:
   ```bash
   ./generate_commit_counts.sh
   ```
2. This script creates a directory named `repo_commit_counts_by_author` and generates a CSV report for each repository, listing the number of commits by each author.

### Aggregated Commit Counts Report

1. Run `aggregate_commits.sh` from the terminal:
   ```bash
   ./aggregate_commits.sh
   ```
2. This script processes all repositories listed in `repo_paths.conf`, aggregates commit counts by author across all repositories, and outputs the results to `aggregate_commits.csv`.

### Output

- The `generate_lines_changed.sh` and `generate_commit_counts.sh` scripts output files named `repo_lines_changed_by_author_[repo_name].csv` and `repo_commit_counts_by_author_[repo_name].csv`, stored in their respective directories.
- The `aggregate_commits.sh` script outputs a file named `aggregate_commits.csv`, summarizing aggregated commit counts by author across all specified repositories.

## Notes

- All scripts exclude merge commits to focus on direct contributions with the exception of aggregate_commits.sh
- The analyses are based on contributions within the last year.
- Ensure your `repo_paths.conf` file contains valid Git repository paths for accurate analysis.
