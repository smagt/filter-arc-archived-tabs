"""
This Python script filters archived entries from a JSON input based on a specified time frame. It reads JSON data from stdin,
filters out entries that were archived or created before a certain cutoff time, and outputs the filtered JSON data to stdout.
The cutoff time is calculated based on the current time minus the specified number of days, hours, and minutes.
"""

import sys
import json
from datetime import datetime, timedelta, timezone

# Define the start date for Mac absolute time, used as a reference point for timestamps
MAC_ABSOLUTE_START = datetime(2001, 1, 1, tzinfo=timezone.utc)

def filter_archived_entries(days, hours, minutes, verbose=False):
    """
    Filters archived entries from JSON input.

    Parameters:
    - days: The number of days to go back from the current time.
    - hours: The number of hours to go back from the current time.
    - minutes: The number of minutes to go back from the current time.
    - verbose: If True, prints the count of original and filtered items to stderr.

    Reads JSON data from stdin, filters out entries based on the specified time frame,
    and outputs the filtered JSON data to stdout.
    """
    # Load JSON data from stdin
    data = json.load(sys.stdin)
    
    # Calculate the cutoff time for filtering
    current_time = datetime.now(timezone.utc)
    cutoff_time = current_time - timedelta(days=days, hours=hours, minutes=minutes)
    
    def is_recent(entry):
        """
        Determines if an entry is recent based on its 'archivedAt' or 'createdAt' timestamp.

        Parameters:
        - entry: The entry to check.

        Returns:
        - True if the entry is recent, False otherwise.
        """
        if isinstance(entry, dict):
            if 'archivedAt' in entry:
                entry_time = MAC_ABSOLUTE_START + timedelta(seconds=entry['archivedAt'])
                return entry_time > cutoff_time
            elif 'createdAt' in entry:
                entry_time = MAC_ABSOLUTE_START + timedelta(seconds=entry['createdAt'])
                return entry_time > cutoff_time
        # Retain items that are not dicts with 'archivedAt' or 'createdAt' field (like strings)
        return True

    # Filter entries based on the is_recent function
    filtered_pairs = [(data['items'][i], data['items'][i+1]) for i in range(0, len(data['items']), 2) if is_recent(data['items'][i+1])]
    filtered_items = [item for pair in filtered_pairs for item in pair]
    
    # Optionally print the count of original and filtered items
    if verbose:
        sys.stderr.write(f"Original items: {len(data['items']) // 2} | Filtered items: {len(filtered_items) // 2}\n")          
    data['items'] = filtered_items
    
    # Output the filtered JSON data to stdout
    json.dump(data, sys.stdout, indent=4)

if __name__ == "__main__":
    # Parse command line arguments
    verbose = False
    args = sys.argv[1:]
    
    # Check for verbose flag
    if "-v" in args or "--verbose" in args:
        verbose = True
        args = [arg for arg in args if arg not in ("-v", "--verbose")]
    
    # Validate the number of arguments
    if len(args) != 3:
        sys.stderr.write("Usage: python filter.py <days> <hours> <minutes> [-v]\n")
        

    days = int(args[0])
    hours = int(args[1])
    minutes = int(args[2])

    filter_archived_entries(days, hours, minutes, verbose)