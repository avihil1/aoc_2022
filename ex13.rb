require 'json'
require 'pp'
require 'set'

DAY=13
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2.45; ru=; session=; _gid=GA1.1670089126' > input#{DAY}`
end

def order?(arr1, arr2,root=false)
  i = 0
  return true  if arr1 == arr2
  return true  if arr1[i].nil? #&& arr2[i].nil?
  return false if !arr1[i].nil? && arr2[i].nil?

  if arr1[i].class != arr2[i].class
    if arr1[i].is_a?(Integer)
      d1 = arr1.dup
      d1[i] = [arr1[i]]
      return order?(d1, arr2)
    else
      d2 = arr2.dup
      d2[i] = [arr2[i]]
      return order?(arr1, d2)
    end
  end

  if arr1[0].is_a?(Array) && arr2[0].is_a?(Array)
    return order?(arr1[1..], arr2[1..]) if arr1[0] == arr2[0]
    return true if order?(arr1[0], arr2[0])
    return false
  end

  if arr1[i].is_a?(Integer) && arr2[i].is_a?(Integer)
    if arr1[i] < arr2[i]
      return true
    elsif arr1[i] > arr2[i]
      return false
    else 
      return order?(arr1[1..], arr2[1..])
    end
  end
  
  return true
end

class Array
  include Comparable
  def <=>(arr2)
    order?(self, arr2) ? -1 : 1
  end
end

def part1
  h = {}
  file=ARGV[0] || "input#{DAY}"
  arr1, arr2 = nil, nil
  idx = 1
  res = 0
  arr = []
  File.open(file).each_line {|l|
    part = l.strip

    if part.nil? || part.empty?
      arr1 = nil
      arr2 = nil
      idx += 1
    end

    if arr1 == nil
      arr1 = eval(part)
      arr << arr1
    else 
      arr2 = eval(part)
      arr << arr2
    end

    if arr1 && arr2
      res += idx if order?(arr1, arr2, true)
    end

  }
  puts res
  # part2
  puts "part2 <<<<<< Starting sorting"
  arr << [[2]]
  arr << [[6]]
  arr.compact!
  arr.sort!
  res = 1
  arr.each_with_index{|a,i| res*=(i+1) if a == [[2]] || a==[[6]]}
  puts res
end
part1
