#!/bin/bash

# This script is designed to clean up and filter JSON data from a specific input file. It takes three numerical arguments
# representing days, minutes, and seconds, and optionally a -v flag for verbose output. The script first validates the input
# JSON file using jq. If the file is valid, it then changes the working directory to a specified location and runs a Python
# script named filter.py with the provided time arguments. The Python script filters the JSON data based on these time parameters.
# The filtered data is saved to an output file. The script supports verbose mode, which provides additional output details
# when the -v flag is used.

verbose=0 # Flag to track verbosity

# Function to print messages in verbose mode
print_verbose() {
    if [ "$verbose" -eq 1 ]; then
        echo "$1"
    fi
}

# Check for optional -v argument
while getopts ":v" opt; do
  case ${opt} in
    v )
      verbose=1
      ;;
    \? )
      echo "Usage: $0 [-v] days minutes seconds" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Check if exactly three arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 [-v] days minutes seconds" >&2
    exit 1
fi

# Define the input and output file paths
INPUT_FILE="$HOME/Library/Application Support/Arc/StorableArchiveItems.json"
OUTPUT_FILE="FilteredStorableArchiveItems.json"

# Check if the input JSON file is valid
if ! jq empty "$INPUT_FILE" > /dev/null 2>&1; then
    echo "Error: The JSON file at '$INPUT_FILE' is not valid." >&2
    exit 1
fi
print_verbose "Input JSON file is valid."

# Change directory to the directory where this script resides
cd "$(dirname "$0")"

# Execute the Python script with the provided arguments and redirect the output
if [ "$verbose" -eq 1 ]; then
    python filter.py "$1" "$2" "$3" -v < "$INPUT_FILE" > "$OUTPUT_FILE"
else
    python filter.py "$1" "$2" "$3" < "$INPUT_FILE" > "$OUTPUT_FILE"
fi

# Check if the output JSON file is valid
if ! jq empty "$OUTPUT_FILE" > /dev/null 2>&1; then
    echo "Error: The generated JSON file at '$OUTPUT_FILE' is not valid." >&2
    rm "$OUTPUT_FILE" # Remove the invalid output file
    exit 1
else
    print_verbose "Filtering complete. Output saved to '$OUTPUT_FILE'."
    print_verbose "The generated JSON file is valid."
    # Before overwriting the original input file with the modified output
    timestamp=$(date "+.%Y-%m-%d-%H-%M-%S") # Generate timestamp
    backup_file="${INPUT_FILE%.json}${timestamp}.json" # Append timestamp before .json extension

    mv "$INPUT_FILE" "$backup_file" # Rename original file to include timestamp
    print_verbose "Original file backed up as '$backup_file'."

    # Maintain at most 20 historic backup files
    backups=$(ls "${INPUT_FILE%.json}".*.json | sort | head -n -20)
    if [ ! -z "$backups" ]; then
        echo "$backups" | xargs rm
        print_verbose "Removed oldest backups, maintaining at most 20 historic files."
    fi

    mv "$OUTPUT_FILE" "$INPUT_FILE" # Now safely overwrite the original input file with the modified output
    print_verbose "Original file has been updated."
fi