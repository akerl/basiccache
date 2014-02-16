BasicCache
========

[![Gem Version](https://badge.fury.io/rb/basiccache.png)](https://badge.fury.io/rb/basiccache)
[![Dependency Status](https://gemnasium.com/akerl/basiccache.png)](https://gemnasium.com/akerl/basiccache)
[![Code Climate](https://codeclimate.com/github/akerl/basiccache.png)](https://codeclimate.com/github/akerl/basiccache)
[![Coverage Status](https://coveralls.io/repos/akerl/basiccache/badge.png?branch=master)](https://coveralls.io/r/akerl/basiccache?branch=master)
[![Build Status](https://travis-ci.org/akerl/basiccache.png?branch=master)](https://travis-ci.org/akerl/basiccache)

Provides a minimal key/value caching layer

## Usage

BasicCache utilizes two different components to cache data:
    * Stores, which are backends for holding keys and values
    * Caches, which handle expiration logic

You can create a new default cache object using `BasicCache.new`:

```
require 'basiccache'
my_cache = BasicCache.new
```

This uses the default Store and Cache object. The default Store is a Ruby hash, and the default Cache does not perform any automatic expiration of keys.

To store things in the cache and retrieve them, use `my_cache.cache` with a code block. When provided no argument, it will infer a key name using the calling method's name. If the key is stored, it will return it. If no key is stored, it will run the computation, store the result, and return it.

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
  1.730000   0.020000   1.750000 (  1.752766)
  0.000000   0.000000   0.000000 (  0.000014)
  0.000000   0.000000   0.000000 (  0.000008)
```

To clear the cache, call `.clear!`. Calling `.clear!(key)` will remove only that key:

```
require 'basiccache'

my_cache = BasicCache.new

(1..10).each { |i| my_cache.cache(i) { i+10 } }

puts my_cache.size

my_cache.clear! 3
puts my_cache.size

my_cache.clear!
puts my_cache.size
```

Results:

```
10
9
0
```

### Using other Caches

In addition to the default Cache object, BasicCache also provides TimeCache, which expires keys after a given lifetime. It can be created similarly to the default Cache, and used identically. The lifetime can be provided, or the default of 60 seconds is used.

```
require 'basiccache'

my_cache = BasicCache::TimeCache.new(lifetime: 3)

my_cache.cache('foo') { (1..50_000).reduce { |acc, i| acc*i } }

puts my_cache.size
sleep 5
puts my_cache.size
```

Results:

```
1
0
```

### Using other Stores

Store backends can be provided to a Cache object when it is created via the `:store` parameter. BasicCache implements only the default Store, but [RedisStore](https://github.com/akerl/redisstore) is an example of an alternate Store class.

```
require 'basiccache'
require 'redisstore'

my_store = RedisStore.new
my_cache = BasicCache.new(store: my_store)

3.times do
    puts Benchmark.measure {
        my_cache.cache('bar') do
            (1..50_000).reduce { |acc, i| acc*i }
        end
    }
end
```

### MethodCacher

MethodCacher provides a helper module for caching method calls inside a class.

To cache the results of Foo.bar and Foo.act, for instance, you'd do the following:

```
require 'basiccache'

class Foo
  include MethodCacher

  def initialize
    enable_caching [:bar, :act]
  end

  def bar
    # deep computation here
  end

  def act
    # more super deep calculations
  end

  def other
    # this method isn't cached
  end
end
```

You can also provide a second argument to enable_caching to specify a custom cache object (like TimeCache):

```
require 'basiccache'

class Foo
  include MethodCacher

  def initialize
    enable_caching [:act], BasicCache::TimeCache.new
  end

  def act
    # super deep time-sensitive calculations
  end
end
```

## Subclasses

### TimeCache

This cache behaves similarly, with the addition of a lifetime attribute.

When creating a new cache object, provide a lifetime or use the default of 30 seconds:

```
default_cache = BasicCache::TimeCache.new
puts "Default Lifetime: #{default_cache.lifetime}"

custom_cache = BasicCache::TimeCache.new(lifetime: 3)
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

## Important Note About Keys

BasicCache attempts to guess the key name from the stack by looking for the name of the method that called it. This is convenient for most use cases, but if you're using metaprogramming or nested code blocks, this can cause that method name to be "block (2 levels) in \<top (required)>" or similar. In this case, keys can conflict and give back weird results. The fix is for you to manually specify your own keys to .cache calls.

## Installation

    gem install basiccache

## License

BasicCache is released under the MIT License. See the bundled LICENSE file for details.

