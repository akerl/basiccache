# coding: UTF-8

require 'coveralls'
Coveralls.wear_merged!

def compute(n)
  (1..n).reduce { |a, e| a * e }
end
