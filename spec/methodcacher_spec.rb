require 'spec_helper'

##
# Example class for testing method caching

class Example
  include MethodCacher

  def initialize(skip_cache = false)
    return if skip_cache
    enable_caching [:repeat]
    enable_caching [:time_repeat], BasicCache::TimeCache.new(1)
  end

  def repeat(input)
    input
  end

  def other_repeat(input)
    input
  end

  def time_repeat(input)
    input
  end

  def not_cached(input)
    input
  end
end

describe MethodCacher do
  let(:test_object) { Example.new }
  let(:uncached_object) { Example.new(skip_cache: true) }

  describe '#enable_caching' do
    it 'wraps methods with the cache' do
      expect(test_object.repeat 2).to eql 2
      expect(test_object.repeat 3).to eql 2
    end
    it "doesn't mess with other instances" do
      expect(uncached_object.repeat 5).to eql 5
      expect(uncached_object.repeat 6).to eql 6
    end
    it 'allows a user-supplied cache object' do
      expect(test_object.time_repeat 2).to eql 2
      expect(test_object.time_repeat 3).to eql 2
      sleep 2
      expect(test_object.time_repeat 4).to eql 4
    end
    it 'does not override other methods' do
      expect(test_object.not_cached 7).to eql 7
      expect(test_object.not_cached 8).to eql 8
    end
    it 'aliases the uncached methods' do
      expect(test_object.repeat_uncached 5).to eql 5
      expect(test_object.repeat_uncached 4).to eql 4
    end
    it 'properly separates keys in the cache' do
      expect(test_object.repeat 8).to eql 8
      expect(test_object.other_repeat 3).to eql 3
    end
  end
end
