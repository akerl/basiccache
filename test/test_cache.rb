require 'test/unit'
require 'benchmark'
require 'basiccache'

class BasicCacheTest < Test::Unit::TestCase
  def compute(n)
    (1..n).reduce { |a, e| a * e }
  end
  
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
    assert_equal cache.store[:test_caching], 3628800
    assert_equal cache.cache, 3628800
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
    trials = 2.times.map { Benchmark.measure { cache.cache { compute(50_000) } }.real }
    assert (trials[0] > trials[1]*1000)
  end
end

