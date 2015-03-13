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
  s.licenses    = ['MIT']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'faraday', '~> 0.9'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.9'
  s.add_runtime_dependency 'rake', '~> 10.3'
  s.add_runtime_dependency 'rspec', '~> 3.1'
  s.add_runtime_dependency 'rubyzip', '~> 1.1'

  s.add_development_dependency 'pry-byebug', '~> 2.0'
end
