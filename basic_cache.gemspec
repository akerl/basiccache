require File.join(Dir.pwd, 'lib/basic_cache.rb')

Gem::Specification.new do |s|
  s.name        = 'basic_cache'
  s.version     = Basic_Cache::Version
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = 'Provides a minimal key/value caching layer'
  s.description = "Allows an application to dynamically cache values and retrieve them later"
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.files       = `git ls-files`.split
  s.homepage    = 'https://github.com/akerl/basic_cache'
  s.license     = 'MIT'
end

