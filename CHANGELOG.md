# Change Log

Starting with v2.0.0, all notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## v2.1.4 - 2016-04-01

### Changed

* Bug in usage of minitar filenames led to ignored tar files with tar file length of >100 chars.

## v2.1.3 - 2016-01-25

### Changed

* PuppetForge::V3::Release.download will now use the "file\_uri" field of the Release API response to calculate the URI to download from. (Thanks to [ericparton](https://github.com/ericparton) for the contribution.)

## v2.1.2 - 2015-12-16

### Changed

* Runtime dependency on "faraday\_middleware" gem updated to allow 0.10.x releases.

## v2.1.1 - 2015-10-06

### Changed

* Bug in error message around missing release on forge caused inappropriate error.

## v2.1.0 - 2015-08-20

### Added

* PuppetForge::ReleaseForbidden added to acknowledge 403 status returned from release download request

## v2.0.0 - 2015-08-13

### Added

* PuppetForge::V3::Release can now verify the md5, unpack, and install a release tarball.
* PuppetForge::Middleware::SymbolifyJson to change Faraday response hash keys into symbols.
* PuppetForge::V3::Metadata to represent a release's metadata as an object.
* PuppetForge::Connection to provide Faraday connections.

### Changed

* Failed API requests, such as those for a module that doesn't exist, throw a Faraday::ResourceNotFound error.
* API requests are sent through Faraday directly rather than through Her.
* PuppetForge::V3::Base#where and PuppetForge::V3::Base#all now send an API request immediately and return a paginated collection.

### Removed

* Dependency on Her (also removes dependency on ActiveSupport).
