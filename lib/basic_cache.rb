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
        # Empty out the store

        def clear
            @store.clear
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

    ##
    # Time-based cache object

    class Time_Cache < Cache
        attr_reader :lifetime

        ##
        # Generate an empty store, with a default lifetime of 60 seconds

        def initialize(lifetime=30)
            @lifetime = lifetime
            @cache_item = Struct.new(:stamp, :value)
            super()
        end

        ##
        # If the key is cached but expired, clear it

        def cache(key = nil, &code)
            key = (key || Basic_Cache::get_caller()).to_sym
            @store[key] = @cache_item.new(Time.now, code.call) unless @store.include? key and Time.now - @store[key].stamp < @lifetime
            @store[key].value
        end
    end
end

