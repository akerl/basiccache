module Basic_Cache
    Version = '0.0.2'

    class << self
        def new(*args)
            self::Cache.new(*args)
        end
    end

    if Kernel.respond_to? 'caller_locations'
        def self.get_caller
            caller_locations(2, 1)[0].label
        end
    else
        def self.get_caller
            caller[1][/`([^']*)'/, 1]
        end
    end

    class Cache
        def initialize
            @store = Hash.new
        end

        def clear
            @store.clear
        end

        def cache(key = nil, &code)
            key ||= Basic_Cache::get_caller()
            return @store[key] if store.include? key
            @store[key] = code.call
        end
    end
end

