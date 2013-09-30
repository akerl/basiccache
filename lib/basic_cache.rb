module Basic_Cache
    Version = '0.0.5'

    class << self
        def new(*args)
            self::Cache.new(*args)
        end
    end

    if Kernel.respond_to? 'caller_locations'
        def self.get_caller
            caller_locations(2, 1).first.label
        end
    else
        def self.get_caller
            caller[1][/`([^']*)'/, 1]
        end
    end

    class Cache
        attr_reader :store

        def initialize
            @store = Hash.new
        end

        def clear
            @store.clear
        end

        def cache(key = nil, &code)
            @store[(key || Basic_Cache::get_caller()).to_sym] ||= code.call
        end
    end
end

