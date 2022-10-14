Gem::Specification.new do |s|
  s.name        = 'basiccache'
  s.version     = '1.0.0'

  s.required_ruby_version = '>= 3.0'

  s.summary     = 'Provides a minimal key/value caching layer'
  s.description = 'Allows an application to dynamically cache values and retrieve them later'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/basiccache'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split

  s.add_development_dependency 'goodcop', '~> 0.9.7'
  s.add_development_dependency 'timecop', '~> 0.9.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
