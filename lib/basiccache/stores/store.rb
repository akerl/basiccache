module BasicCache
  ##
  # Basic store object (uses a Hash)
  class Store
    attr_reader :data

    ##
    # Generate an empty store

    def initialize(_ = {})
      @data = {}
    end

    ##
    # Clears a specified key or the whole store

    def clear!(key = nil)
      key.nil? ? @data.clear : @data.delete(key)
    end

    ##
    # Retrieve a key

    def [](key)
      @data[key]
    end

    ##
    # Set a key

    def []=(key, value)
      @data[key] = value
    end

    ##
    # Return the size of the store

    def size
      @data.size
    end

    ##
    # Check for a key in the store

    def include?(key)
      @data.include? key
    end

    ##
    # Array of keys in the store

    def keys
      @data.keys
    end
  end
end
