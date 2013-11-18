BasicCache
========

[![Gem Version](https://badge.fury.io/rb/basiccache.png)](https://badge.fury.io/rb/basiccache)
[![Dependency Status](https://gemnasium.com/akerl/basiccache.png)](https://gemnasium.com/akerl/basiccache)
[![Code Climate](https://codeclimate.com/github/akerl/basiccache.png)](https://codeclimate.com/github/akerl/basiccache)
[![Build Status](https://travis-ci.org/akerl/basiccache.png?branch=master)](https://travis-ci.org/akerl/basiccache)

Provides a minimal key/value caching layer

## Usage

First, initialize a caching object:

```
require 'basiccache'
my_cache = BasicCache.new
```

From then on, when you want to cache the results of some processing, just call my_cache.cache(key) with the processing block:

```
require 'basiccache'
require 'benchmark'

my_cache = BasicCache.new

3.times do
    puts Benchmark.measure {
        my_cache.cache('foo') do
            (1..50_000).reduce { |acc, i| acc*i }
        end
    }
end
```

Results:

```
# ruby example.rb
  1.690000   0.000000   1.690000 (  1.698418)
  0.000000   0.000000   0.000000 (  0.000011)
  0.000000   0.000000   0.000000 (  0.000005)
```

To clear the cache, call .clear!:

```
my_cache = BasicCache.new

# do stuff

my_cache.clear!
```

The .clear! method can be passed a key name to clear just a specific key, as well.

## Subclasses

### TimeCache

This cache behaves similarly, with the addition of a lifetime attribute.

When creating a new cache object, provide a lifetime or use the default of 30 seconds:

```
default_cache = BasicCache::TimeCache.new
puts "Default Lifetime: #{default_cache.lifetime}"

custom_cache = BasicCache::TimeCache.new(3)
puts "Default Lifetime: #{custom_cache.lifetime}"

custom_cache.cache('test') { "fish" }
puts "Does the cache include 'test'? #{custom_cache.include? 'test'}"
sleep 5
puts "Does the cache include 'test' now? #{custom_cache.include? 'test'}"
```

This returns the following:

```
Default Lifetime: 30
Default Lifetime: 3
Does the cache include 'test'? true
Does the cache include 'test' now? false
```

## Installation

    gem install basiccache

## License

BasicCache is released under the MIT License. See the bundled LICENSE file for details.

