# Cronex

[![Gem Version](https://badge.fury.io/rb/cronex.svg)](https://badge.fury.io/rb/cronex)
[![Build Status](https://github.com/alpinweis/cronex/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/alpinweis/cronex/actions/workflows/test.yml?query=branch%3Amaster)

A Ruby library that converts cron expressions into human readable strings.
Translated to Ruby from [cron-expression-descriptor](https://github.com/bradyholt/cron-expression-descriptor) (C#) via
[cron-parser](https://github.com/RedHogs/cron-parser) (Java).

Original Author & Credit: Brady Holt (http://www.geekytidbits.com).

## Features

 * Supports all cron expression special characters including: `*` `/` `,` `-` `?` `L` `W` `#`
 * Supports 5, 6 (w/ seconds or year), or 7 (w/ seconds and year) part cron expressions
 * Provides casing options (sentence, title, lower)
 * Support for non-standard non-zero-based week day numbers
 * Supports printing to locale specific human readable format
 * Supports displaying times in specific timezones

For a quick intro to cron see Quartz [Cron Tutorial](http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html).

## Available Locales

* English
* Brazilian
* Dutch
* French
* German
* Italian
* Romanian
* Russian

## Installation

Add this line to your application's Gemfile:

    gem 'cronex'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cronex

## Usage

#### Zero based day of week

    Cronex::ExpressionDescriptor.new('*/5 15 * * 1-5').description
    => Every 5 minutes, at 3:00 PM, Monday through Friday

    Cronex::ExpressionDescriptor.new('0 0/30 8-9 5,20 * ?').description
    => Every 30 minutes, between 8:00 AM and 9:59 AM, on day 5 and 20 of the month

#### Non-zero based day of week

    Cronex::ExpressionDescriptor.new('*/5 15 * * 1-5', zero_based_dow: false).description
    => Every 5 minutes, at 3:00 PM, Sunday through Thursday

#### Localization

    Cronex::ExpressionDescriptor.new('30 2 * 2 1-5', locale: 'fr').description
    => À 2:30 AM, lundi à vendredi, seulement en février

#### Timezones

    Cronex::ExpressionDescriptor.new('0-10 11 * * *', timezone: 'America/Los_Angeles').description
    => Every minute between 4:00 AM and 4:10 AM # PDT or
    => Every minute between 3:00 AM and 3:10 AM # PST

### Strict quartz-scheduler implementation support

    Cronex::ExpressionDescriptor.new('* * * * *', strict_quartz: true).description
    => Cronex::ExpressionError (Error: Expression only has 5 parts. For 'strict_quartz' option, at least 6 parts are required)

See spec tests for more examples.

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
