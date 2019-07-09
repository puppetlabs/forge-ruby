# Puppet Forge

Access and manipulate the [Puppet Forge API](https://forgeapi.puppetlabs.com)
from Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'puppet_forge'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet_forge

## Requirements

* Ruby >= 1.9.3

## Dependencies

* [Faraday]() >= 0.9.0 < 0.14.0
* [Typhoeus](https://github.com/typhoeus/typhoeus) ~> 1.0.1 (optional)

Typhoeus will be used as the HTTP adapter if it is available, otherwise
Net::HTTP will be used. We recommend using Typhoeus for production-level
applications.

## Usage

First, make sure you have imported the Puppet Forge gem into your application:

```ruby
require 'puppet_forge'
```

Next, supply a user-agent string to identify requests sent by your application
to the Puppet Forge API:

```ruby
PuppetForge.user_agent = "MyApp/1.0.0"
```

Now you can make use of the resource models defined by the gem:

* [PuppetForge::V3::User][user_ref]
* [PuppetForge::V3::Module][module_ref]
* [PuppetForge::V3::Release][release_ref]

For convenience, these classes are also aliased as:

* [PuppetForge::User][user_ref]
* [PuppetForge::Module][module_ref]
* [PuppetForge::Release][release_ref]

[user_ref]: https://github.com/puppetlabs/forge-ruby/wiki/Resource-Reference#puppetforgeuser
[module_ref]: https://github.com/puppetlabs/forge-ruby/wiki/Resource-Reference#puppetforgemodule
[release_ref]: https://github.com/puppetlabs/forge-ruby/wiki/Resource-Reference#puppetforgerelease

__The aliases will always point to the most modern API implementations for each
model.__ You may also use the fully qualified class names
(e.g. PuppetForge::V3::User) to ensure your code is forward compatible.

See the [Basic Interface](#basic-interface) section below for how to perform
common tasks with these models.

Please note that PuppetForge models are identified by unique slugs rather
than numerical identifiers.

The slug format, properties, associations, and methods available on each
resource model are documented on the [Resource Reference][resource_ref] page.

[resource_ref]: https://github.com/puppetlabs/forge-ruby/wiki/Resource-Reference

### Basic Interface

Each of the models uses ActiveRecord-like REST functionality to map over the Forge API endpoints.
Most simple ActiveRecord-style interactions function as intended.

Currently, only unauthenticated read-only actions are supported.

The methods find, where, and all immediately make one API request.

```ruby
# Find a Resource by Slug
PuppetForge::User.find('puppetlabs') # => #<Forge::V3::User(/v3/users/puppetlabs)>

# Find All Resources
PuppetForge::Module.all # See "Paginated Collections" below for important info about enumerating resource sets.

# Find Resources with Conditions
PuppetForge::Module.where(query: 'apache') # See "Paginated Collections" below for important info about enumerating resource sets.
PuppetForge::Module.where(query: 'apache').first # => #<Forge::V3::Module(/v3/modules/puppetlabs-apache)>
```

For compatibility with older versions of the puppet\_forge gem, the following two methods are functionally equivalent.

```ruby
PuppetForge::Module.where(query: 'apache')
PuppetForge::Module.where(query: 'apache').all # This method is deprecated and not recommended
```

#### Errors

All API Requests (whether via find, where, or all) will raise a Faraday::ResourceNotFound error if the request fails.


### Installing a Release

A release tarball can be downloaded and installed by following the steps below.

```ruby
release_slug = "puppetlabs-apache-1.6.0"
release_tarball = release_slug + ".tar.gz"
dest_dir = "/path/to/install/directory"
tmp_dir = "/path/to/tmpdir"

# Fetch Release information from API
# @raise Faraday::ResourceNotFound error if the given release does not exist
release = PuppetForge::Release.find release_slug

# Download the Release tarball
# @raise PuppetForge::ReleaseNotFound error if the given release does not exist
release.download(Pathname(release_tarball))

# Verify the MD5
# @raise PuppetForge::V3::Release::ChecksumMismatch error if the file's md5 does not match the API information
release.verify(Pathname(release_tarball))

# Unpack the files to a given directory
# @raise RuntimeError if it fails to extract the contents of the release tarball
PuppetForge::Unpacker.unpack(release_tarball, dest_dir, tmp_dir)
```


### Paginated Collections

The Forge API only returns paginated collections as of v3.

```ruby
PuppetForge::Module.all.total # => 1728
PuppetForge::Module.all.length # => 20
```

Movement through the collection can be simulated using the `limit` and `offset`
parameters, but it's generally preferable to leverage the pagination links
provided by the API. For convenience, pagination links are exposed by the
library.

```ruby
PuppetForge::Module.all.offset # => 0
PuppetForge::Module.all.next_url # => "/v3/modules?limit=20&offset=20"
PuppetForge::Module.all.next.offset # => 20
```

An enumerator exists for iterating over the entire (unpaginated) collection.
Keep in mind that this will result in multiple calls to the Forge API.

```ruby
PuppetForge::Module.where(query: 'php').total # => 37
PuppetForge::Module.where(query: 'php').unpaginated # => #<Enumerator>
PuppetForge::Module.where(query: 'php').unpaginated.to_a.length # => 37
```

### Associations & Lazy Attributes

Associated models are accessible in the API by property name.

```ruby
PuppetForge::Module.find('puppetlabs-apache').owner # => #<Forge::V3::User(/v3/users/puppetlabs)>
```

Properties of associated models are then loaded lazily.

```ruby
user = PuppetForge::Module.find('puppetlabs-apache').owner

# This does not trigger a request
user.username # => "puppetlabs"

# This *does* trigger a request
user.created_at # => "2010-05-19 05:46:26 -0700"
```

### i18n

When adding new error or log messages please follow the instructions for
[writing translatable code](https://github.com/puppetlabs/gettext-setup-gem#writing-translatable-code).

The PuppetForge gem will default to outputing all error messages in English, but you may set the locale
using the `FastGettext.set_locale` method. If translations do not exist for the language you request then the gem will
default to English. The `set_locale` method will return the locale, as a string, that FastGettext will now
use to report PuppetForge errors.

```ruby
# Assuming the German translations exist, this will set the reporting language
# to German

locale = FastGettext.set_locale "de_DE"

# If it successfully finds Germany's locale, locale will be "de_DE"
# If it fails to find any German locale, locale will be "en"
```

## Caveats

This library currently does no response caching of its own, instead opting to
re-issue every request each time. This will be changed in a later release.

## Reporting Issues

Please report problems, issues, and feature requests on the public
[Puppet Labs issue tracker][issues] under the FORGE project. You will need
to create a free account to add new tickets.

[issues]: https://tickets.puppetlabs.com/browse/FORGE

## Contributing

1. Fork it ( https://github.com/[my-github-username]/forge-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Releasing

1. Make sure version, changelog, etc. have been updated.
1. Commit and tag with new version number: e.g. `v1.2.3`
1. Push tag to Github: `git push upstream --tags` (where `upstream` is the remote name of the puppetlabs fork of this repo)
1. Wait for Travis CI to test and push new release to Rubygems.

## Contributors

* Pieter van de Bruggen, Puppet Labs
* Jesse Scott, Puppet Labs
* Austin Blatt, Puppet Labs
* Adrien Thebo, Puppet Labs
* Anderson Mills, Puppet Labs

## Maintenance

Tickets: File at https://tickets.puppet.com/browse/FORGE
