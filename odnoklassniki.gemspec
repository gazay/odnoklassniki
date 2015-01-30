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
  s.description = %q{Ruby wrapper for Odnoklassniki API}

  s.rubyforge_project = 'odnoklassniki'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.add_dependency 'httparty'
  s.add_dependency 'multi_json'
end
