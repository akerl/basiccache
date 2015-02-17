##
# Helper module for caching methods inside a class
# To use, extend your class with MethodCacher
# Then, in initialize, call enable_caching
module MethodCacher
  ##
  # Enable caching for the listed methods

  def enable_caching(methods, cache = nil)
    cache ||= BasicCache.new
    methods.each do |name|
      uncached_name = "#{name}_uncached".to_sym
      singleton_class.class_eval do
        alias_method uncached_name, name
        define_method(name) do |*a, &b|
          cache.cache(name) { send uncached_name, *a, &b }
        end
      end
    end
  end
end
