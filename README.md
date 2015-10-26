#Cronex

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

For a quick intro to cron see Quartz [Cron Tutorial](http://www.quartz-scheduler.org/documentation/quartz-1.x/tutorials/crontrigger).

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

See spec tests for more examples.

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
