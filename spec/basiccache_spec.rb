require 'spec_helper'

describe BasicCache do
  describe '::VERSION' do
    it 'follows the semantic version scheme' do
      expect(BasicCache::VERSION).to match /\d+\.\d+\.\d+/
    end
  end

  describe '.new' do
    it 'creates cache objects' do
      expect(BasicCache.new).to be_an_instance_of BasicCache::Cache
    end
  end

  describe '.get_caller' do
    it "returns the calling function's name" do
      expect(BasicCache.get_caller).to eql 'instance_eval'
    end
    it 'uses caller_locations on Ruby 2.0.0+' do
      expect(BasicCache::NEW_CALL).to be_true if RUBY_VERSION.to_i >= 2
    end
    it 'uses caller on Ruby 1.x' do
      expect(BasicCache::NEW_CALL).to be_false if RUBY_VERSION.to_i < 2
    end
  end
end
