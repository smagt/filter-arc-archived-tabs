# Clean Arc Project

## Overview

The Clean Arc project is designed to clean up and filter JSON data from a specific input file, focusing on data related to the Arc browser. It uses a shell script (`clean-arc.sh`) to validate and process JSON data, filtering it based on time parameters (days, minutes, and seconds) provided by the user. The project aims to streamline the management of Storable Archive Items from the Arc browser, making it easier to handle and analyze data over specific time periods.

## Features

- **Data Validation**: Ensures the input JSON file is valid using `jq`.
- **Data Filtering**: Filters the JSON data based on user-specified time parameters.
- **Verbose Mode**: Offers an optional verbose mode for additional output details.

## Getting Started

### Prerequisites

- **jq**: A lightweight and flexible command-line JSON processor. [jq documentation](https://stedolan.github.io/jq/)
- **Python**: Ensure Python is installed for running the `filter.py` script. [Python installation guide](https://www.python.org/downloads/)

### Installation

1. **Clone the Repository**: Clone this repository to your local machine using Git.

    ```bash
    git clone https://github.com/your-repository/clean-arc.git
    cd clean-arc
    ```

2. **Install jq**: If you haven't installed `jq`, you can do so by following the instructions on the [jq GitHub page](https://github.com/stedolan/jq).

3. **Set Up the plist**: The project includes a plist file for scheduling the script on macOS. To install it:

    - Modify the plist file to include the correct path to the `clean-arc.sh` script.
    - Copy the plist file to `~/Library/LaunchAgents`.
    - Load the plist with the following command:

        ```bash
        launchctl load ~/Library/LaunchAgents/your.plist
        ```

### Running the Script

To run the `clean-arc.sh` script, navigate to the project directory and execute the script with three numerical arguments representing days, minutes, and seconds. Optionally, you can include the `-v` flag for verbose output.

```bash
./clean-arc.sh [-v] <days> <minutes> <seconds>
