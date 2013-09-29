module Basic_Cache
    Version = '0.0.1'

    class << self
        def new(*args)
            self::Cache.new(*args)
        end
    end

    if RUBY_VERSION.to_i >= 2
        def get_caller
            caller_locations(2, 1)[0].label
        end
    else
        def get_caller
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

        def is_cached?(key = nil)
            key ||= Basic_Cache::get_caller()
        end
    end
end

