require 'spec_helper.rb'

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
end
