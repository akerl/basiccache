# coding: UTF-8

require 'simplecov'
require 'simplecov-gem-adapter'
SimpleCov.start('gem')

require 'coveralls'
Coveralls.wear_merged!

def compute(n)
  (1..n).reduce { |a, e| a * e }
end
