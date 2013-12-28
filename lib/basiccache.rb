##
# This module provides a simple key/value cache for storing computation results

module BasicCache
  # Check if we're using a version if Ruby that supports caller_locations
  NEW_CALL = Kernel.respond_to? 'caller_locations'

  class << self
    ##
    # Insert a helper .new() method for creating a new Cache object

    def new(*args)
      self::Cache.new(*args)
    end

    ##
    # Provide a helper method to get the calling function name
    # If available, caller_locations is available and is much faster.
    # If not, fall back to caller
    # These methods return the name of the calling function 2 levels up
    # This allows them to return the name of whatever called Cache.cache()

    def caller_name
      NEW_CALL ? caller_locations(2, 1).first.label : caller[1][/`([^']*)'/, 1]
    end
  end
end

require 'stores/store'
require 'caches/cache'
require 'caches/timecache'
require 'methodcacher'
