$:.push File.expand_path('../lib', __FILE__)
require 'jscrambler/version'

Gem::Specification.new do |s|
  s.name        = 'jscrambler'
  s.version     = JScrambler::VERSION
  s.date        = '2014-09-25'
  s.authors     = ['José P. Airosa']
  s.email       = ['me@joseairosa.com']
  s.homepage    = 'https://jscrambler.com/'
  s.summary     = %q{JScrambler Client for Ruby}
  s.description = %q{JScrambler helps you keep your applications safe and less vulnerable to fraud or any other attacks.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'json'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'rake'
  s.add_dependency 'rspec'
  s.add_dependency 'rubyzip'

  s.add_development_dependency 'byebug'
end
