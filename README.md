BasicCache
========

[![Gem Version](https://img.shields.io/gem/v/basiccache.svg)](https://rubygems.org/gems/basiccache)
[![Build Status](https://img.shields.io/circleci/project/akerl/basiccache/master.svg)](https://circleci.com/gh/akerl/basiccache)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/basiccache.svg)](https://codecov.io/github/akerl/basiccache)
[![Code Quality](https://img.shields.io/codacy/4d51cd5021024c539a6e007dfcd2dc6e.svg)](https://www.codacy.com/app/akerl/basiccache)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Provides a minimal key/value caching layer

## Installation

    gem install basiccache

## Usage

_API docs can be found at http://www.rubydoc.info/github/akerl/basiccache_

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

### Important Note About Keys

BasicCache attempts to guess the key name from the stack by looking for the name of the method that called it. This is convenient for most use cases, but if you're using metaprogramming or nested code blocks, this can cause that method name to be "block (2 levels) in \<top (required)>" or similar. In this case, keys can conflict and give back weird results. The fix is for you to manually specify your own keys to .cache calls.

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
require 'benchmark'

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

Results:

```
  0.000000   0.000000   0.000000 (  0.001434)
  0.000000   0.000000   0.000000 (  0.000294)
  0.000000   0.000000   0.000000 (  0.000207)
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

## Extending BasicCache

Creating your own Cache or Store is pretty simple. These are the required methods that each needs to provide:

Cache:
* `.size()` -> Size of the cache as an integer. Expired/invalid keys should not count towards this.
* `.cache(key = nil, &block)` -> If key exists, return stored value; if not, run block, store value, and return it. If no key is provided, use BasicCache.caller_name to infer one.
* `.include?(key = nil)` -> Return boolean indicating presence of key in Cache. Expired/invalid keys should return false. If no key is provided, use BasicCache.caller_name to infer one.
* `.[](key)` -> Return value if key is cached, else return KeyError
* `.clear!(key = nil)` -> With no key, clear the whole cache and return {}. With a key, clear that key and return the value it had.
* `.prune()` -> Prune expired/invalid keys from the store. Return any pruned keys.

Store:
* `.clear!(key = nil)` -> With no key, clear the whole cache and return {}. With a key, clear that key and return the value it had.
* `.[](key)` -> Return the value stored for the given key if it exists, else return KeyError.
* `.[]=(key, value)` -> Store the given value with the given key, and return the value.
* `.size()` -> Return the size of the store as an integer.
* `.include?(key)` -> Return a boolean indicating presence of the given key in the store.
* `.keys()` -> Return all keys in the store as an array.

## License

BasicCache is released under the MIT License. See the bundled LICENSE file for details.

