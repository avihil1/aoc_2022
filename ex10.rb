require 'json'
require 'pp'
require 'set'
DAY=10
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=; ru=; session=; _gid=GA1.2.5399308.' > input#{DAY}`
end

def multi_cycle(cycles, v, h)
  h[cycles] = v*cycles
end

def draw_lit?(cycles, loc)
  cycles = cycles%40-1
  
  loc-1 == cycles ||
  loc   == cycles ||
  loc+1 == cycles
end

def part2
  arr = [] 
  240.times.each {|i| arr << '.'}
  file="input#{DAY}"
  #file="test#{DAY}"
  x=1
  cycles=0
  
  File.open(file).each_line {|l|
    parts = l.strip.split
    cycle = parts[0] == 'noop' ? 1 : 2
 
    cycle.times.each {|_|
      cycles += 1
      arr[cycles-1] = '#' if draw_lit?(cycles, x)
    } 
    x += parts[1].to_i if parts[1]
  }
  p cycles
  
  a = ""
  arr.each_with_index {|t,i|
    a += t
    if ((i+1) % 40) == 0
      puts a
      a =""
    end
  }
end

def part1
  h = {}
  file="input#{DAY}"
  x=1
  cycles=0
  File.open(file).each_line {|l|
    parts = l.strip.split
    cycle = parts[0] == 'noop' ? 1 : 2
   
    cycle.times.each {|i|
      cycles += 1
      if cycles > 0 && cycles < 240 && ((cycles-20)%40 == 0)
        multi_cycle(cycles, x, h)
      end
    }

    x += parts[1].to_i if parts[1]
  }
  p h.values.sum
end
part2
