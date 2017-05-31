##
# This module provides a simple key/value cache for storing computation results
module BasicCache
  class << self
    ##
    # Insert a helper .new() method for creating a new Cache object

    def new(*args)
      self::Cache.new(*args)
    end

    ##
    # Provide a helper method to get the calling function name
    # This method returns the name of the calling function 2 levels up
    # This allows them to return the name of whatever called Cache.cache()

    def caller_name
      caller_locations(2, 1).first.label
    end
  end
end

require 'basiccache/stores/store'
require 'basiccache/stores/nullstore'
require 'basiccache/caches/cache'
require 'basiccache/caches/timecache'
require 'basiccache/methodcacher'
