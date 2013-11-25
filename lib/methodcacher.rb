##
# Helper module for caching methods inside a class
# To use, extend your class with MethodCacher
# Then, in initialize, call enable_caching

module MethodCacher
  def enable_caching(cache: nil, methods: nil)
    cache ||= BasicCache.new
    methods ||= []
    methods.each do |name|
      uncached_name = "#{name}_uncached".to_sym
      (class << self; self; end).class_eval do
        alias_method uncached_name, name
        define_method(name) { |*a| cache.cache { send uncached_name, *a } }
      end
    end
  end
end
