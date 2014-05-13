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

## Usage

First, make sure you have imported the Puppet Forge gem into your application:

``` ruby
require 'puppet_forge'
```

Now you can make use of the resource models defined by the gem:

* PuppetForge::User
* PuppetForge::Module
* PuppetForge::Release

See the "Basic Interface" section below for how to perform common tasks with these models.

Please note that Puppet Forge resources are identified by unique "slugs" rather than
numerical identifiers.

The properties and associations available on each resource as well as the slug format for
that resource are defined below:

#### PuppetForge::User

Slug Format: `<username>`

``` ruby
user = PuppetForge::User.find('puppetlabs')
```

##### Properties

Property      | Description                             | Example
------------- | --------------------------------------- | ----------------------------------------
username      | Username                                | <pre>>> user.username<br>=> "puppetlabs"</pre>
display_name  | Preferred display name                  | <pre>>> user.display_name<br>=> "Puppet Labs"</pre>
module_count  | Number of modules owned by user         | <pre>>> user.module_count<br>=> 78</pre>
release_count | Total release for modules owned by user | <pre>>> user.release_count<br>=> 425</pre>
gravatar_id   | Unique identifier for user's Gravatar   | <pre>>> user.gravatar_id<br>=> "fdd009b7c1ec96e088b389f773e87aec"</pre>
created_at    | Date and time user was created          | <pre>>> user.created_at<br>=> "2010-05-19 05:46:26 -0700"</pre>
updated_at    | Date and time user was last updated     | <pre>>> user.updated_at<br>=> "2014-02-26 12:30:59 -0800"</pre>

#####Associations

Association   | Description                                    | Example
------------- | ---------------------------------------------- | ----------------------------------------
modules       | Relation scoped to modules owned by this user  | <pre>>> user.modules.total<br>=> 78</pre>

#### PuppetForge::Module

Slug Format: `<owner>-<name>`

``` ruby
mod = PuppetForge::Module.find('puppetlabs-apache')
```

##### Properties

Property      | Description                              | Example
------------- | ---------------------------------------- | ----------------------------------------
name          | Module name                              | <pre>>> mod.name<br>=> "apache"</pre>
downloads     | Total download count for module          | <pre>>> mod.downloads<br>=> 177029</pre>
supported     | Boolean indicating if the module has at least one release officially supported by Puppet Labs | <pre>>> mod.supported<br>=> true</pre>
homepage_url  | URL for module's homepage                | <pre>>> mod.homepage_url<br>=> "https://github.com/puppetlabs/puppetlabs-apache"</pre>
issues_url    | URL for reporting issues/bugs for module | <pre>>> mod.issues_url<br>=> "https://tickets.puppetlabs.com"</pre>
created_at    | Date and time module was first published | <pre>>> mod.created_at<br>=> "2010-05-20 22:43:19 -0700"</pre>
updated_at    | Date and time module information was last updated | <pre>>> mod.updated_at<br>=> "2014-05-14 13:07:03 -0700"</pre>

##### Associations

Association     | Description                                        | Example
--------------- | -------------------------------------------------- | ----------------------------------------
owner           | PuppetForge::User object representing Module owner | <pre>>> mod.owner<br>=> #<PuppetForge::V3::User></pre>
current_release | PuppetForge::Release object representing the release of this module with the highest version number (according to Semantic Versioning specification) | <pre>>> mod.current_release<br>=> #<PuppetForge::V3::Release></pre>
releases        | Array of PuppetForge::Release objects representing all the releases of this module, sorted in descending version order | <pre>>> mod.releases.size<br>=> 20</pre>

#### PuppetForge::Release

Slug Format: `<owner>-<module_name>-<version>`

``` ruby
release = PuppetForge::Release.find('puppetlabs-apache-1.0.1')
```

##### Properties

Property      | Description                               | Example
------------- | ----------------------------------------- | ----------------------------------------
version       | Version number of release                 | <pre>>> release.version<br>=> "1.0.1"</pre>
downloads     | Download count for release                | <pre>>> release.downloads<br>=> 27431</pre>
supported     | Boolean indicating if release is officially supported by Puppet Labs | <pre>>> release.supported<br>=> true</pre>
file_size     | File size of release tarball in bytes     | <pre>>> release.file_size<br>=> 100158</pre>
file_md5      | MD5 hash of release tarball               | <pre>>> release.file_md5<br>=> "2dae3bfc6ad74494414927ad21e79837"</pre>
readme        | HTML version of release README            | <pre>>> release.readme</pre>
changelog     | HTML version of release CHANGELOG         | <pre>>> release.changelog</pre>
license       | HTML version of release LICENSE           | <pre>>> release.license</pre>
tags          | Array of tags applied to this release     | <pre>>> release.tags<br>=> ["apache", "web", "virtualhost",<br>"httpd", "centos", "rhel", "debian",<br>"ubuntu", "apache2", "ssl", "passenger",<br>"wsgi", "proxy", "virtual_host"]</pre>
metadata      | ActiveSupport::HashWithIndifferentAccess representing the contents of this release's metadata.json. | <pre>>> release.metadata</pre>
download_url  | URL for downloading release tarball       | <pre>>> release.download_url</pre>
created_at    | Date and time release was first published | <pre>>> release.created_at<br>=> "2014-03-04 16:26:19 -0800"</pre>
updated_at    | Date and time release information was last updated | <pre>>> release.updated_at<br>=> "2014-03-04 16:26:19 -0800"</pre>

##### Associations

Association     | Description                                        | Example
--------------- | -------------------------------------------------- | ----------------------------------------
module          | PuppetForge::Module object representing the parent module of this release. | <pre>>> release.module<br>=> #<PuppetForge::V3::Module></pre>

##### Methods

Method          | Description                                        | Example
--------------- | -------------------------------------------------- | ----------------------------------------
download(file)  | Download release tarball and save it to the passed in filename. | <pre>>> release.download('/tmp/puppetlabs-apache-1.0.1.tar.gz')</pre>

### Basic Interface

Each of the models uses [Her](http://her-rb.org), and ActiveRecord-like REST
library, to map over the Forge API endpoints. As such, most simple ActiveRecord
interactions function as intended.

Currently, only unauthenticated read-only actions are supported.

``` ruby
# Find a Resource by Slug
PuppetForge::User.find('puppetlabs') # => #<Forge::V3::User(/v3/users/puppetlabs)>

# Find All Resources
PuppetForge::Module.all # See "Paginated Collections" below for important info about enumerating resource sets.

# Find Resources with Conditions
PuppetForge::Module.where(query: 'apache').all # See "Paginated Collections" below for important info about enumerating resource sets.
PuppetForge::Module.where(query: 'apache').first # => #<Forge::V3::Module(/v3/modules/puppetlabs-apache)>
```

### Paginated Collections

The Forge API only returns paginated collections as of v3.

``` ruby
PuppetForge::Module.all.total # => 1728
PuppetForge::Module.all.length # => 20
```

Movement through the collection can be simulated using the `limit` and `offset`
parameters, but it's generally preferable to leverage the pagination links
provided by the API. For convenience, those are exposed by the library as well.

``` ruby
PuppetForge::Module.all.offset # => 0
PuppetForge::Module.all.next_url # => "/v3/modules?limit=20&offset=20"
PuppetForge::Module.all.next.offset # => 20
```

Since iterating over the entire (unpaginated) collection is a reasonably common
need, an enumerator exists for that as well. Keep in mind that this will result
in multiple calls to the Forge API.

``` ruby
PuppetForge::Module.where(query: 'php').total # => 37
PuppetForge::Module.where(query: 'php').unpaginated # => #<Enumerator>
PuppetForge::Module.where(query: 'php').unpaginated.to_a.length # => 37
```

### Associations & Lazy Attributes

Associated models are accessible in the API by property name.

``` ruby
PuppetForge::Module.find('puppetlabs-apache').owner # => #<Forge::V3::User(/v3/users/puppetlabs)>
```

Properties of associated models are then loaded lazily.

``` ruby
user = PuppetForge::Module.find('puppetlabs-apache').owner

# This does not trigger a request
user.username # => "puppetlabs"

# This *does* trigger a request
user.created_at # => "2010-05-19 05:46:26 -0700"
```

## Caveats

This library currently does no response caching of its own, instead opting to
re-issue every request each time. This will be changed in a later release.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/forge-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
