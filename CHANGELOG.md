# Change Log

Starting with v2.0.0, all notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## v2.2.3 - 2017-01-17

### Changed

* Fixed an issue that was preventing PuppetForge.host from honoring any given path prefix.
* Upgraded gettext-setup dependency to 0.11 release.

## v2.2.2 - 2016-07-06

### Changed

* Externalized all user facing strings with gettext to support future localization work.

## v2.2.1 - 2016-05-24

### Changed

* Fixed an issue where certain types of connection failures raised a spurious "method missing" error instead of the underlying
  exception.
* When setting PuppetForge::Connection.proxy, an empty string will now be treated as nil. If no proxy has yet been configured,
  setting to an empty string will have no effect. If a proxy has already been configured, setting to nil will unset the existing
  value.

## v2.2.0 - 2016-05-10

### Changed

* puppet\_forge's optional dependency on Typhoeus now searches for a gem matching '~> 1.0.1' so it will pick up more recent versions.
  NOTE: This means if you have a version of Typhoeus installed that is less than 1.0.1, puppet\_forge will no longer use the Typhoeus
  adapter and will fall back to Ruby's Net::HTTP library.

## v2.1.5 - 2016-04-13

### Added

* PuppetForge::Connection now has .proxy and .proxy= class methods providing a more reliable way of configuring an HTTP proxy.

### Changed

* Cached connection objects will now be automatically discarded when proxy or authorization config has changed.

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
