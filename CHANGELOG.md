# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).i

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

* Depency on Her (also removes dependency on ActiveSupport).
