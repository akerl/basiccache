require 'test/unit'
require 'benchmark'
require 'basiccache'

class TimeCacheTest < Test::Unit::TestCase
  def compute(n)
    (1..n).reduce { |a, e| a * e }
  end
  
  def test_creation
    a = BasicCache::TimeCache.new
    assert_instance_of BasicCache::TimeCache, a
    assert_equal a.store, {}
    assert_equal a.lifetime, 30
    b = BasicCache::TimeCache.new(10)
    assert_equal b.lifetime, 10
  end

  def test_caching
    cache = BasicCache::TimeCache.new
    cache.cache { compute(10) }
    assert cache.store.include? :test_caching
    assert_equal cache.store[:test_caching], 3628800
    assert_equal cache.cache, 3628800
  end

  def test_clearing
    cache = BasicCache::TimeCache.new
    cache.cache { compute(10) }
    assert_equal cache.store.length, 1
    cache.clear!
    assert_equal cache.store.length, 0
  end

  def test_speed_increase
    cache = BasicCache::TimeCache.new
    trials = 2.times.map { Benchmark.measure { cache.cache { compute(50_000) } }.real }
    assert (trials[0] > trials[1]*1000)
  end

  def test_expiration
    cache = BasicCache::TimeCache.new(3)
    cache.cache(:test) { 100 }
    assert cache.include? :test
    sleep 5
    assert not cache.include? :test
  end
end

