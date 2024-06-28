# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cronex/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'cronex'
  spec.version       = Cronex::VERSION
  spec.summary       = 'Ruby library that converts cron expressions into human readable strings'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/alpinweis/cronex'

  spec.authors       = ['Adrian Kazaku']
  spec.email         = ['alpinweis@gmail.com']

  spec.required_ruby_version = '>= 1.9.3'

  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'tzinfo'
  spec.add_runtime_dependency 'unicode', '>= 0.4.4.5'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
