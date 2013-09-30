basic\_cache
========

Provides a minimal key/value caching layer

## Usage

First, initialize a caching object:

```
require 'basic_cache'
my_cache = Basic_Cache.new
```

From then on, when you want to cache the results of some processing, just call my_cache.cache(key) with the processing block:

```
require 'basic_cache'
require 'benchmark'

my_cache = Basic_Cache.new

3.times do
    puts Benchmark.measure {
        my_cache.cache('foo') do
            (1..50_000).inject { |acc, i| acc*i }
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

To clear the cache, call .clear:

```
my_cache = Basic_Cache.new

# do stuff

my_cache.clear
```

## Installation

    gem install basic_cache

## License

basic\_cache is released under the MIT License. See the bundled LICENSE file for details.

