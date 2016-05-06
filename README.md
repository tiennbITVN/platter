[![Code Climate](https://codeclimate.com/github/IcaliaLabs/platter/badges/gpa.svg)](https://codeclimate.com/github/IcaliaLabs/platter)
[![Test Coverage](https://codeclimate.com/github/IcaliaLabs/platter/badges/coverage.svg)](https://codeclimate.com/github/IcaliaLabs/platter/coverage)
[![Issue Count](https://codeclimate.com/github/IcaliaLabs/platter/badges/issue_count.svg)](https://codeclimate.com/github/IcaliaLabs/platter)

# [Platter](https://github.com/IcaliaLabs/platter)

[![Gem Version](https://badge.fury.io/rb/platter.svg)](http://badge.fury.io/rb/platter)

**Platter** is the evolution of [railsAppCustomGenerator](https://github.com/IcaliaLabs/railsAppCustomGenerator) with the intention to create rails app with the basic setup we use at [@icalialabs](http://icalialabs.com). It was created by [Abraham Kuri](https://twitter.com/kurenn) from [Icalia Labs](http://twitter.com/icalialabs).*

**Platter needs ruby 2.2.1 in order to run**

## Table of contents
- [Installation](#installation)
- [Usage](#usage)
- [What it actually do?](#what-it-actually-do)
- [Bug tracker & feature request](#bug-tracker-&-feature-request)
- [Contributing](#contributing)
- [Community](#community)
- [Heroes](#heroes)
- [License](#license)

## Quick start

To install the gem you can just run the following command:

```console
% gem install platter
```

You now have access to the `platter` command through the CLI.

## Usage

To create a rails app the Icalia way, just use the platter command:

```console
% platter anIcaliaWayRailsApp
```

This will create a rails app with the bare bones to start building an app at [Icalia](http://icalialabs.com)

### Options for platter

| Option Name  | Description | Alias | Default |
| ------------- | ------------- | ------------- | ------------- |
| --database  | Configure for selected database. PostgreSQL by default.  | -d | postgresql |
| --skip\_test_unit | Skip Test::Unit files  | -T | true |
| --skip\_turbo_links | Skips the turbolinks gem | - | true |
| --api | Adds API support gems and directory bare bones | - | true |
| --skip\_bundle | Don't run bundle install | -B | true |

### Api
--

```console
% platter anIcaliaWayRailsApp --api
```

## What it actually do?

Platter comes with a lot of goodies. 

**The Gemfile looks like:**

```ruby
source "https://rubygems.org"

ruby "2.2.1"

gem "rails", "4.2.1"
gem "delayed_job_active_record"
gem "jquery-rails"
gem "pg"
gem "sass-rails", "~> 5.0"
gem "coffee-rails", "~> 4.1.0"
gem "uglifier", ">= 1.3.0"
gem "puma"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.1.0"
  gem "ffaker"
end

# Test gems
group :test do
  gem "database_cleaner"
  gem "shoulda-matchers"
end

# Production and staging gems
group :production, :staging do
  gem "rails_12factor"
  gem "exception_notification"
end
```

It will also:

1. Setup the testing environment with Rspec, FactoryGirl, DatabaseCleaner.
2. Setup an staging environment to deploy to this environment
3. Provides the necessary configuration for the PUMA server run with Foreman
4. A setup script for new developers
5. Adds configuration for ActiveJob and DelayedJob
6. In case of an API, it will add Versionist and ActiveModelSerializers, along with a version 1 structure.
7. Adds configuration for ActionMailer to run with Sendgrid
8. Setup the project with git providing an initial commit


## Bug tracker & feature request

For bugs and feature request, head to the [issues](https://github.com/IcaliaLabs/platter/issues) section and if necessary create one.


## Contributing

Please submit all pull requests against a separate branch. Please follow the standard for naming the variables, mixins, etc.

In case you are wondering what to attack, we hnow have a milestone with the version to work, some fixes and refactors. Feel free to start one.

Also remember to respect the [Code of Conduct](https://github.com/IcaliaLabs/platter/blob/master/CODE_OF_CONDUCT.md) for open source projects.

Thanks!

## Community

Keep track of new feautres, development issues and community news.

* Have a question about anything, email us at weare@icalialabs.com


## Heroes

**Abraham Kuri**

+ [http://twitter.com/kurenn](http://twitter.com/kurenn)
+ [http://github.com/kurenn](http://github.com/kurenn)
+ [http://klout.com/#/kurenn](http://klout.com/#/kurenn)


## Copyright and license

Code and documentation copyright 2013-2014 Icalia Labs. Code released under [the MIT license](LICENSE).
