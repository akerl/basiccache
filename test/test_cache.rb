# coding: UTF-8

require 'helper'
require 'test/unit'
require 'benchmark'
require 'basiccache'

##
# Let's cache some stuff!

class BasicCacheTest < Test::Unit::TestCase
  def test_creation
    a = BasicCache.new
    b = BasicCache::Cache.new
    assert_instance_of BasicCache::Cache, a
    assert_instance_of BasicCache::Cache, b
    assert_equal a.store, {}
    assert_equal b.store, {}
  end

  def test_caching
    cache = BasicCache.new
    cache.cache { compute(10) }
    assert cache.store.include? :test_caching
    assert_equal cache.store[:test_caching], 3_628_800
    assert_equal cache.cache, 3_628_800
  end

  def test_clearing
    cache = BasicCache.new
    cache.cache { compute(10) }
    assert_equal cache.store.length, 1
    cache.clear!
    assert_equal cache.store.length, 0
  end

  def test_speed_increase
    cache = BasicCache.new
    trials = 2.times.map do
      Benchmark.measure { cache.cache { compute(50_000) } }.real
    end
    assert trials[0] > trials[1] * 1_000
  end
end
