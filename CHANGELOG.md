# Changelog

All notable changes to the Clean Arc Tabs Archive project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1](https://github.com/smagt/filter-arc-archived-tabs/releases/tag/0.2.1) - 2023-06-29

### Added
time stamps for error and output messages
 
## [0.2.0](https://github.com/smagt/filter-arc-archived-tabs/releases/tag/0.2.0) - 2023-06-26

### Fixed
- now actually runs with plist. Added hardcoded positions of python and jq.  
- check if jk is installed, and don't fail if not

## [0.1.0](https://github.com/smagt/filter-arc-archived-tabs/releases/tag/0.1.0) - 2023-06-24

### Added
- Initial release of the Clean Arc Tabs Archive.
- Shell script `clean-arc.sh` for cleaning up and filtering JSON data from the Arc Browser Archived Tabs file.
- Data validation using `jq` to ensure the input JSON file is valid.
- Data filtering based on user-specified time parameters (days, minutes, and seconds).
- Optional verbose mode for additional output details.
- Version Compatibility section in README.md to document tested versions of operating systems, Arc Browser, `jq`, and Python.
- Disclaimer and warning in README.md regarding the use of the script and its implications.

### Fixed
- N/A

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Security
- N/A

[Unreleased]: ...
[0.1.0]: ...