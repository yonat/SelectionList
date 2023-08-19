# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)

and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- add privacy manifest PrivacyInfo.xcprivacy.

## [1.4.0] - 2019-10-09

### Added
- support two-finger pan gesture to select multiple items.

## [1.3.2] - 2019-08-22

### Added
- support Swift Package Manager.

### Fixed
- fix Interface Builder render error.

## [1.3.1] - 2019-06-21

### Changed
- Swift 5, CocoaPods 1.7.

## [1.3.0] - 2018-09-05

### Changed
- Swift 4.2

## [1.2.0] - 2018-07-04

### Added
- send `primaryActionTriggered` event as well as `valueChanged`.

## [1.1.1] - 2018-05-21

### Changed
- use SwiftLint and SwiftFormat

## [1.1] - 2018-04-02

### Fixed
- update selection marks changed by user taps.

### Changed
- update to Swift 4.1

## [1.0.2] - 2018-03-29

### Fixed
- changing `selectedIndex` didn't work.

## [1.0.1] - 2018-03-28

### Added
- `lastChangedIndex` property.

### Fixed
- update selection marks after manually setting `selectedIndexes`.
- ensure correct list height on first appearance.

### Changed
- moved selection appearance responsibility to cell.

## [1.0] - 2018-03-27

### Added
- first public release.
