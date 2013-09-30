require 'test/unit'
require 'benchmark'
require 'basic_cache'

class Basic_Cache_Test < Test::Unit::TestCase

    $compute = Proc.new { |n| (1..n).inject { |acc, i| acc*i } }

    def test_creation
        a = Basic_Cache.new
        b = Basic_Cache::Cache.new
        assert_instance_of Basic_Cache::Cache, a
        assert_instance_of Basic_Cache::Cache, b
        assert_equal a.store, {}
        assert_equal b.store, {}
    end

    def test_caching
        cache = Basic_Cache.new
        cache.cache { $compute.call(10) }
        assert cache.store.include? :test_caching
        assert_equal cache.store[:test_caching], 3628800
        assert_equal cache.cache, 3628800
    end

    def test_clearing
        cache = Basic_Cache.new
        cache.cache { $compute.call(10) }
        assert_equal cache.store.length, 1
        cache.clear
        assert_equal cache.store.length, 0
    end

    def test_speed_increase
        cache = Basic_Cache.new
        trials = 2.times.map { Benchmark.measure { cache.cache { $compute.call(50_000) } }.real }
        assert (trials[0] > trials[1]*1000)
    end
end

