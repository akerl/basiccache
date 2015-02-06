require 'spec_helper'

describe BasicCache::Store do
  let(:store) do
    store = BasicCache::Store.new
    (1..5).each { |i| store[i] = i + 5 }
    store
  end

  describe '#initialize' do
    it 'creates a new store raw object' do
      expect(store.raw).to be_an_instance_of Hash
    end
  end
  describe '#clear!' do
    describe 'when given no argument' do
      it 'empties the store' do
        expect(store.clear!).to eql({})
      end
    end
    describe 'when given an argument' do
      it 'removes a key from the store' do
        expect(store.size).to eql 5
        store.clear! 1
        expect(store.size).to eql 4
      end
    end
  end
  describe '#[]' do
    it 'retrieves a key' do
      expect(store[1]).to eql 6
    end
  end
  describe '#[]=' do
    it 'sets a key' do
      expect(store[6] = 10).to eql 10
    end
  end
  describe '#size' do
    it 'returns the size of the store' do
      expect(store.size).to eql 5
    end
  end
  describe '#include?' do
    it 'checks for a key in the store' do
      expect(store.include? :foo).to be_falsey
      expect(store.include? 1).to be_truthy
    end
  end
  describe '#keys' do
    it 'lists the keys in the store' do
      expect(store.keys).to eql [1, 2, 3, 4, 5]
    end
  end
end
