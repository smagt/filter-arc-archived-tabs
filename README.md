# Clean Arc Tabs Archive

Written by Patrick van der Smagt

**Warning.**
This code as only been tested on MacOS Sonoma 14.5 and Arc browser 1.48.2 (51225).

**Disclaimer:**
Usage of this script is at your own risk. The authors are not responsible for any damage or data loss resulting from the use of this script. Ensure you have backups and understand the implications before running the script.  It does overwrite Arc system files.

## Overview

The Clean Arc project is designed to clean up and filter JSON data from the Arc Browser Archived Tabs file, thus allowing you to automatically delete old entries from the Arc Archived tabs.

It uses a shell script (`clean-arc.sh`) to validate and process the archived tabs, filtering them based on time parameters (how many days, minutes, and seconds an entry is old) provided by the user. 

_Note that running the script does not reflect in what happens in the browser; for that, unfortunately, Arc must be restarted._

## Features

- **Data Validation**: Ensures the input JSON file is valid using `jq`.
- **Data Filtering**: Filters the JSON data based on user-specified time parameters.
- **Verbose Mode**: Offers an optional verbose mode for additional output details.

## Getting Started

### Prerequisites

- **jq**: A lightweight and flexible command-line JSON processor. [jq documentation](https://stedolan.github.io/jq/)
- **Python**: Ensure Python is installed for running the `filter.py` script. [Python installation guide](https://www.python.org/downloads/)

## Version Compatibility

This project has been tested and is known to work with the following versions:

- **Operating System**: MacOS Sonoma 14.5
- **Arc Browser**: Version 1.48.2 (51225)
- **jq**: Version 1.7.1
- **Python**: Version 3.12.2

Please note that while the project may work with versions not listed here, these are the environments in which it has been tested and confirmed to function as expected. Future versions of the software and dependencies may introduce breaking changes that could affect the functionality of this project.

### Installation

1. **Clone the Repository**: Clone this repository to your local machine using Git.

    ```bash
    git clone git@github.com:smagt/filter-arc-archived-tabs
    cd clean-arc
    ```

2. **Optional**: run `rye init` and `rye sync` to get the correct Python version and dependencies.  It's optional, since most systems have a running Python version, and the script was written to only require standard libraries.

3. **Install jq**: If you haven't installed `jq`, you can do so by following the instructions on the [jq GitHub page](https://github.com/stedolan/jq).  Typically, `brew install jq` will do the job if you have `brew`.

Note that `jq` is not strictly necessary; it is used to check in- and output and thus highly recommended.

4. **Set Up the plist**: The project includes a plist file for scheduling the script on macOS. To install it:

    - Modify the plist file to include the correct path to the `clean-arc.sh` script and the correct days etc.
    - Copy the plist file to `~/Library/LaunchAgents`.
    - Load the plist with the following command:

        ```bash
        launchctl load ~/Library/LaunchAgents/com.user.clean-arc.plist
        ```

### Running the Script

To run the `clean-arc.sh` script, navigate to the project directory and execute the script with three numerical arguments representing days, minutes, and seconds. Optionally, you can include the `-v` flag for verbose output.

```bash
./clean-arc.sh [-v] <days> <minutes> <seconds>
```

## Current Version

Version 0.1.0

## Changelog

For the changes in each version, please refer to the [CHANGELOG.md](CHANGELOG.md) file.