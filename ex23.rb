require 'json'
require 'pp'
require 'set'

DAY=23
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2..1669061645; ru=; session=; _gid=GA1.2.5399308.' > input#{DAY}`
end

def parse_row(row)
  row.chars
end

def add_elv(set, i, j)
  set << [i,j]
end

def elv?(set, i, j)
  set.include?([i,j])
end

def move_north?(s, i, j)
  !elv?(s, i-1, j) && !elv?(s, i-1, j-1) && !elv?(s, i-1, j+1)
end

def move_south?(s, i, j)
  !elv?(s, i+1, j) && !elv?(s, i+1, j-1) && !elv?(s, i+1, j+1)
end

def move_west?(s, i, j)
  !elv?(s, i, j-1) && !elv?(s, i-1, j-1) && !elv?(s, i+1, j-1)
end

def move_east?(s, i, j)
  !elv?(s, i, j+1) && !elv?(s, i-1, j+1) && !elv?(s, i+1, j+1)
end

def shouldnt_move?(s, i ,j)
  !(elv?(s, i-1, j) || elv?(s, i-1, j+1) || elv?(s, i, j+1) || elv?(s, i+1, j+1) ||
    elv?(s, i+1, j) || elv?(s, i+1, j-1) || elv?(s, i, j-1) || elv?(s, i-1, j-1))
end

def ij(i,j); "#{i},#{j}"; end
def to_arr(k); k.split(',').map(&:to_i); end
def declare_move(set, round=0)
  h = {}
  set.each{|item|
    i,j = item
    next if shouldnt_move?(set, i, j)

    arr_of_choice = []
    arr_of_choice << (move_north?(set,i,j) ? [i-1,j] : nil)
    arr_of_choice << (move_south?(set,i,j) ? [i+1,j] : nil)
    arr_of_choice << (move_west?(set,i,j) ? [i,j-1] : nil)
    arr_of_choice << (move_east?(set,i,j) ? [i,j+1] : nil)
    
    round.upto(round+3).each {|r|
      if arr_of_choice[r%4]
        newi, newj = arr_of_choice[r%4]
        h[ij(newi, newj)] = [] if h[ij(newi, newj)].nil?
        h[ij(newi, newj)] << [i,j]
        break
      end
    } 
  }
  h
end

def move(elves, k ,v)
  elves.delete(k)
  elves << v
end

def calc_area(s)
  up_i = 100
  down_i = 0
  left_j = 100
  right_j = 0
  s.each {|item|
    i,j = item

    up_i = i if i < up_i
    down_i = i if i > down_i
    left_j = j if j < left_j
    right_j = j if j > right_j
  }

  puts "#{up_i}, #{down_i}, #{left_j}, #{right_j} | #{s.length}"
  puts "Part1: #{(down_i-up_i+1)*(right_j-left_j+1) - s.length}"
end

def print_arr(elves, max_i, max_j)
  0.upto(max_i-1).each{|i|
    row = ""
    0.upto(max_j-1).each{|j|
      row += elv?(elves, i,j) ? '#' : '.'
    }
    puts row
  }
end

def part1
  file=ARGV[0] || "input#{DAY}"
  hsh = Hash.new
  elves = Set.new
  idx=0
  i = 0
  max_i, max_j = 0, 0
  File.open(file).each_line {|l|
     chars = parse_row(l.strip)
     max_j = chars.length
     chars.each_with_index {|c,jj|
       add_elv(elves, idx, jj) if c == '#'
     }
     idx += 1
  }
  max_i = idx

  # part 1
  puts "#items: #{idx}"
  #print_arr(elves, max_i, max_j)
  1.upto(5000).each{|ii|
    moved = false
    h = declare_move(elves, ii-1)
    h.each {|k,v|
      if v.length == 1 && !v.empty?
        move(elves, v[0], to_arr(k))
        moved = true
      end
    }
    if !moved # Part2
      puts "Part2: #{ii}"
      break
    end
    if ii == 10
      calc_area(elves)
    end
  }
  
end
part
