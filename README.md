# Settings::Env::Loader

Scan ENV and override correspondong settings in a nested Hash

The Hash must provide all configuration options. It eases the deployment to platform such as heroku.

It is recommended to use settingslogic to load settings first, and then merge ENV into it.

## Installation

Add this line to your application's Gemfile:

    gem 'settings-env-loader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install settings-env-loader

## Usage

Extend hash object:

    hash.extend SettingsEnvLoader

Call `merge_env`

    hash.merge_env

Use `each_env` to export all configuratable options:

    hash.each_env do |k, v|
      puts "export #{k}=#{v.inspect}"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
