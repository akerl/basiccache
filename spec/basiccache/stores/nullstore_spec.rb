require 'spec_helper'

describe BasicCache::NullStore do
  let(:store) { BasicCache::NullStore.new }

  describe '#initialize' do
    it 'creates a new null store object' do
      expect(store.raw).to be_nil
    end
  end
  describe '#clear!' do
    it 'always returns true' do
      expect(store.clear!).to be_truthy
      expect(store.clear!(5)).to be_truthy
    end
  end
  describe '#[]' do
    it 'always returns nil' do
      expect(store[1]).to be_nil
    end
  end
  describe '#[]=' do
    it 'returns the provided value' do
      expect(store[6] = 10).to eql 10
      expect(store[6]).to be_nil
    end
  end
  describe '#size' do
    it 'returns zero' do
      expect(store.size).to eql 0
    end
  end
  describe '#include?' do
    it 'always returns false' do
      expect(store.include? :foo).to be_falsey
      expect(store.include? 1).to be_falsey
    end
  end
  describe '#keys' do
    it 'is always an empty array' do
      expect(store.keys).to eql []
    end
  end
end
