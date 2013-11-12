##
# This module provides a simple key/value cache for storing computation results

module Basic_Cache
    Version = '0.0.8'

    class << self
        ##
        # Insert a helper .new() method for creating a new Cache object

        def new(*args)
            self::Cache.new(*args)
        end
    end

    ##
    # If we're using 2.0.0+, caller_locations is available and is much faster.
    # If not, fall back to caller
    # These methods return the name of the calling function 2 levels up
    # This allows them to return the name of whatever called Cache.cache()

    if Kernel.respond_to? 'caller_locations'
        def self.get_caller
            caller_locations(2, 1).first.label
        end
    else
        def self.get_caller
            caller[1][/`([^']*)'/, 1]
        end
    end

    ##
    # Cache object, maintains a key/value store

    class Cache
        attr_reader :store

        ##
        # Generate an empty store

        def initialize
            @store = Hash.new
        end

        ##
        # Empty out either the given key or the full store

        def clear!(key = nil)
            key.nil? @store.clear : @store.delete(key)
        end

        ##
        # If the key is cached, return it.
        # If not, run the code, cache the result, and return it

        def cache(key = nil, &code)
            @store[(key || Basic_Cache::get_caller()).to_sym] ||= code.call
        end

        ##
        # Return the size of the cache

        def size
            @store.length
        end
    end
end

