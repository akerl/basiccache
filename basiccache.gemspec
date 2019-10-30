Gem::Specification.new do |s|
  s.name        = 'basiccache'
  s.version     = '1.0.0'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Provides a minimal key/value caching layer'
  s.description = 'Allows an application to dynamically cache values and retrieve them later' # rubocop:disable Metrics/LineLength
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/basiccache'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.5.0'
  s.add_development_dependency 'goodcop', '~> 0.8.0'
  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rubocop', '~> 0.76.0'
  s.add_development_dependency 'timecop', '~> 0.9.0'
end
