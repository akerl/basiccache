require 'spec_helper'

describe BasicCache do
  describe '#new' do
    it 'creates cache objects' do
      expect(BasicCache.new).to be_an_instance_of BasicCache::Cache
    end
  end

  describe '#caller_name' do
    it "returns the calling function's name" do
      expect(BasicCache.caller_name).to eql 'instance_exec'
    end
  end
end
