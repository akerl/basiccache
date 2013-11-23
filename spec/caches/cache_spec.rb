require 'spec_helper.rb'

describe BasicCache::Cache do
  it 'creates a cache' do
    expect(subject).to be_an_instance_of BasicCache::Cache
  end
  it 'has a hash store' do
    expect(subject.store).to eql Hash.new
  end
end
