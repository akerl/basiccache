##
# This module provides a simple key/value cache for storing computation results

module BasicCache
  VERSION = '0.0.17'

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
end

require 'caches/cache'
require 'caches/timecache'
