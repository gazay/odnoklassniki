lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odnoklassniki/version'

Gem::Specification.new do |s|
  s.name        = 'odnoklassniki'
  s.version     = Odnoklassniki::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['gazay']
  s.licenses    = ['MIT']
  s.email       = ['alex.gaziev@gmail.com']
  s.homepage    = 'https://github.com/gazay/odnoklassniki'
  s.summary     = %q{Ruby wrapper for Odnoklassniki API}
  s.description = %q{Ruby wrapper for REST Odnoklassniki API calls. GET and POST calls.}

  s.rubyforge_project = 'odnoklassniki'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.add_dependency "faraday",            '~> 0.9',  '>= 0.9.0'
  s.add_dependency "faraday_middleware", '~> 0.9',  '>= 0.9.0'
  s.add_dependency "multi_json",         '~> 1.10', '>= 1.10.0'
  s.add_development_dependency 'pry',                '0.10.1'
  s.add_development_dependency 'byebug',             '3.5.1'
  s.add_development_dependency 'pry-byebug',         '3.0.0'
  s.add_development_dependency 'minitest',           '5.5.1'
  s.add_development_dependency 'minitest-reporters', '1.0.10'
  s.add_development_dependency 'simplecov',          '0.9.1'
  s.add_development_dependency 'rake',               '10.1.0'
  s.add_development_dependency 'vcr',                '2.9.3'
  s.add_development_dependency 'webmock',            '1.20.4'
end
