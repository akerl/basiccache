module BasicCache
  ##
  # No-op store object, does not store information
  class NullStore
    attr_reader :data

    ##
    # Generate an empty store

    def initialize(_ = {})
      @data = nil
    end

    ##
    # Clears a specified key or the whole store

    def clear!(*_)
      true
    end

    ##
    # Retrieve a key

    def [](_)
      nil
    end

    ##
    # Set a key

    def []=(_, value)
      value
    end

    ##
    # Return the size of the store

    def size
      0
    end

    ##
    # Check for a key in the store

    def include?(_)
      false
    end

    ##
    # Array of keys in the store

    def keys
      []
    end
  end
end
