# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'settings-env-loader'

Gem::Specification.new do |gem|
  gem.name          = "settings-env-loader"
  gem.version       = Settings::Env::Loader::VERSION
  gem.authors       = ["Ian Yang"]
  gem.email         = ["me@iany.me"]
  gem.description   = %q{Scan ENV and override correspondong settings in a nested Hash}
  gem.summary       = %q{
    The Hash must provide all configuration options. It
    eases the deployment to platform such as heroku.

    It is recommended to use settingslogic to load settings first, and then
    merge ENV into it.
  }
  gem.homepage      = "https://github.com/doitian/settings-env-loader"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
