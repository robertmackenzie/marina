[![Build Status](https://drone.io/github.com/robertmackenzie/marina/status.png)](https://drone.io/github.com/robertmackenzie/marina/latest)

# Marina

Encourages you to declare any hosts file entries you need alongside your project in a Hostspec file. You can then use this tool to update your hosts file against your Hostspec file. Similar style to gems with bundler.

## Installation

Add this line to your application's Gemfile:

    gem 'marina'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marina

## Usage

Add a Hostspec file to the root of your project. Fill it will host name in the
following format:

    host 'win.com'
    host 'epic.win.com'

Then run `sudo marina` and these will be added to /etc/hosts.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
