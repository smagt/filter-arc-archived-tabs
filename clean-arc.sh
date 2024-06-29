#!/bin/bash

# This script is designed to clean up and filter JSON data from a specific input file. It takes three numerical arguments
# representing days, minutes, and seconds, and optionally a -v flag for verbose output. The script first validates the input
# JSON file using jq. If the file is valid, it then changes the working directory to a specified location and runs a Python
# script named filter.py with the provided time arguments. The Python script filters the JSON data based on these time parameters.
# The filtered data is saved to an output file. The script supports verbose mode, which provides additional output details
# when the -v flag is used.


# the next logic is to add time stamps to outout and error messages
# Capture start time
start_time=$(date "+%Y-%m-%d %H:%M:%S")

# Create temporary files for stdout and stderr
temp_stdout=$(mktemp)
temp_stderr=$(mktemp)

# Redirect stdout and stderr to the temporary files
exec 3>&1 4>&2 1>"$temp_stdout" 2>"$temp_stderr"



# script starts
verbose=0 # Flag to track verbosity

PYTHON=/usr/bin/python3
JQ=/opt/homebrew/bin/jq

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

# Check for jq installation
jq_installed=1
if ! command -v $JQ &> /dev/null; then
    echo "Warning: jq is not found. JSON validation will be skipped."
    jq_installed=0
fi


# Define the input and output file paths
INPUT_FILE="$HOME/Library/Application Support/Arc/StorableArchiveItems.json"
OUTPUT_FILE="FilteredStorableArchiveItems.json"

# Check if the input JSON file is valid, only if jq is installed
if [ "$jq_installed" -eq 1 ]; then
    if ! $JQ empty "$INPUT_FILE" > /dev/null 2>&1; then
        echo "Error: The JSON file at '$INPUT_FILE' is not valid." >&2
        exit 1
    fi
    print_verbose "Input JSON file is valid."
fi

# Change directory to the directory where this script resides
cd "$(dirname "$0")"

# Execute the Python script with the provided arguments and redirect the output
if [ "$verbose" -eq 1 ]; then
    $PYTHON filter.py "$1" "$2" "$3" -v < "$INPUT_FILE" > "$OUTPUT_FILE"
else
    $PYTHON filter.py "$1" "$2" "$3" < "$INPUT_FILE" > "$OUTPUT_FILE"
fi

# Check if the output JSON file is valid, only if jq is installed
if [ "$jq_installed" -eq 1 ]; then
    if ! $JQ empty "$OUTPUT_FILE" > /dev/null 2>&1; then
        echo "Error: The generated JSON file at '$OUTPUT_FILE' is not valid." >&2
        rm "$OUTPUT_FILE" # Remove the invalid output file
        exit 1
    fi
fi

print_verbose "Filtering complete. Output saved to '$OUTPUT_FILE'."
print_verbose "The generated JSON file is valid."
# Before overwriting the original input file with the modified output
timestamp=$(date "+.%Y-%m-%d-%H-%M-%S") # Generate timestamp
backup_file="${INPUT_FILE%.json}${timestamp}.json" # Append timestamp before .json extension

mv "$INPUT_FILE" "$backup_file" # Rename original file to include timestamp
print_verbose "Original file backed up as '$backup_file'."

# Maintain at most 20 historic backup files
# Calculate the total number of lines minus 20
total_lines=$(ls "${INPUT_FILE%.json}".*.json | wc -l)
let lines_to_keep=total_lines-20

# Use tail to get all but the last 20 lines, if the calculation is positive
if [ $lines_to_keep -gt 0 ]; then
    backups=$(ls "${INPUT_FILE%.json}".*.json | sort | tail -n $lines_to_keep)
else
    backups=""
fi
if [ ! -z "$backups" ]; then
    echo "$backups" | xargs rm
    print_verbose "Removed oldest backups, maintaining at most 20 historic files."
fi

mv "$OUTPUT_FILE" "$INPUT_FILE" # Now safely overwrite the original input file with the modified output
print_verbose "Original file has been updated."


# now output the messaging
# Restore stdout and stderr
exec 1>&3 3>&- 2>&4 4>&-

# Check and print stdout if not empty
if [ -s "$temp_stdout" ]; then
    echo "Output Timestamp: $start_time"
    cat "$temp_stdout"
fi

# Check and print stderr if not empty
if [ -s "$temp_stderr" ]; then
    echo "Error Timestamp: $start_time" >&2
    cat "$temp_stderr" >&2
fi

# Cleanup
rm "$temp_stdout" "$temp_stderr"