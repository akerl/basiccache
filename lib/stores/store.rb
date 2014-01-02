module BasicCache
  ##
  # Basic store object (uses a Hash)

  class Store
    attr_reader :raw

    ##
    # Generate an empty store

    def initialize
      @raw = {}
    end

    ##
    # Clear the store

    def clear!
      @raw.clear
    end

    ##
    # Delete a specific key

    def delete(key)
      @raw.delete key
    end

    ##
    # Retrieve a key

    def [](key)
      @raw[key]
    end

    ##
    # Set a key

    def []=(key, value)
      @raw[key] = value
    end

    ##
    # Return the size of the store

    def size
      @raw.size
    end

    ##
    # Check for a key in the store

    def include?(key)
      @raw.include? key
    end

    ##
    # Array of keys in the store

    def keys
      @raw.keys
    end
  end
end
