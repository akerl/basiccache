require 'spec_helper.rb'

describe BasicCache::Cache do
  let(:cache) do
    subject.cache('a') { 3 }
    subject.cache('b') { 5 }
    subject
  end

  it 'creates a cache' do
    expect(subject).to be_an_instance_of BasicCache::Cache
  end
  it 'has a hash store' do
    expect(subject.store).to eql Hash.new
  end
  describe '#size' do
    it 'shows the size of the cache' do
      expect(cache.size).to eql 2
      expect(BasicCache.new.size).to eql 0
    end
  end
  describe '#cache' do
    it 'caches values' do
      cache.cache('c') { 1 }
      expect(cache.cache('c') { 2 }).to eql 1
      expect(cache.include? 'c'). to be_true
    end
  end
  describe '#clear!' do
    describe 'when given no argument' do
      it 'clears the cache' do
        expect(cache.size).to eql 2
        cache.clear!
        expect(cache.size).to eql 0
      end
    end
    describe 'when given an argument' do
      it 'removes that entry from the cache' do
        expect(cache.size).to eql 2
        cache.clear! 'c'
        expect(cache.size).to eql 2
        p cache.store
        expect(cache.clear! 'a').to eql 3
        expect(cache.size).to eql 1
        expect(cache.clear! :b).to eql 5
        expect(cache.size).to eql 0
      end
    end
  end
  describe '#include?' do
    it 'checks for a value in the cache' do
      expect(cache.include? 'a').to be_true
      expect(cache.include? :b).to be_true
      expect(cache.include? 'z').to be_false
    end
  end
  describe '#[]' do
    it 'returns values from the cache' do
      expect(cache['a']).to eql 3
      expect(cache[:b]).to eql 5
      expect { cache[:c] }.to raise_error KeyError
    end
  end
end
