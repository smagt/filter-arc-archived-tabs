"""
This script reads a JSON input from stdin, which is expected to contain a list of items under the 'items' key. Each item is a dictionary that may contain 'archivedAt' or 'createdAt' timestamps, representing the time the item was archived or created, respectively. These timestamps are in seconds since the Mac absolute time start (2001-01-01). The script finds the oldest entry based on these timestamps and prints the date of the oldest entry in ISO format. If no valid entries are found, it prints a message indicating so.
"""
import sys
import json
from datetime import datetime, timedelta
import pytz

# Mac absolute time starts at 2001-01-01
MAC_ABSOLUTE_START = datetime(2001, 1, 1, tzinfo=pytz.utc)

def find_oldest_entry():
    data = json.load(sys.stdin)
    oldest_time = None

    for entry in data['items']:
        if isinstance(entry, dict):
            entry_time = None
            if 'archivedAt' in entry:
                entry_time = MAC_ABSOLUTE_START + timedelta(seconds=entry['archivedAt'])
            elif 'createdAt' in entry:
                entry_time = MAC_ABSOLUTE_START + timedelta(seconds=entry['createdAt'])
            
            if entry_time and (oldest_time is None or entry_time < oldest_time):
                oldest_time = entry_time

    if oldest_time:
        print(f"Oldest entry date: {oldest_time.isoformat()}")
    else:
        print("No valid entries found.")

if __name__ == "__main__":
    find_oldest_entry()