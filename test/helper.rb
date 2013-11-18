# coding: UTF-8

def compute(n)
  (1..n).reduce { |a, e| a * e }
end
