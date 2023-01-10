require 'json'
require 'pp'
require 'set'

DAY=14
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2..1669061645; ru=; session=; _gid=GA1.2..1670089126' > input#{DAY}`
end

def draw_air(arr,n,m)
  n.times.each{|_| arr << ['.'] * m}
end

def draw_rock(arr, a, b, max_row=0)
  j1, i1 = a
  j2, i2 = b

  max_row = i1 if i1 > max_row
  max_row = i2 if i2 > max_row
  if i1 != i2
    if i1 < i2
      while i1 <= i2
        arr[i1][j1] = '#'
        i1+=1
      end
    else
      while i1 >= i2
        arr[i1][j1] = '#'
        i1-=1
      end
    end
  end

  if j1 != j2
    if j1 < j2
      while j1 <= j2
        arr[i1][j1] = '#'
        j1+=1
      end
    else
      while j1 >= j2
        arr[i1][j1] = '#'
        j1-=1
      end
    end
  end
end

FAIL=-1
SUCCESS=1

def down?(arr, i, j)
  arr[i+1][j] == '.'
end

def down_left?(arr, i, j)
  j > 0 &&  arr[i+1][j-1] == '.'
end

def down_right?(arr, i , j)
  !['o','#'].include?(arr[i+1][j+1])
end

def blocked?(arr, i ,j)
  ['o','#'].include?(arr[i+1][j]) &&
  ['o','#'].include?(arr[i+1][j-1]) &&
  ['o','#'].include?(arr[i+1][j+1])
end

def limbo?(arr, i, j)
  blocked?(arr, i, j) && i==0 && j==500
end

def add_sand(arr, i, j)
  if limbo?(arr, i, j)
    return FAIL
  elsif blocked?(arr, i ,j)
    arr[i][j] = 'o'
    return SUCCESS
  end

  if down?(arr, i, j)
    return add_sand(arr, i+1, j)
  end
  if down_left?(arr, i ,j)
    return add_sand(arr, i+1, j-1)
  end
  if down_right?(arr, i, j)
    return add_sand(arr, i+1, j+1)
  end
end

def part1
  h = {}
  file=ARGV[0] || "input#{DAY}"
  arr = []
  cnt = 0
  max_row=0
  draw_air(arr, 166, 930)
  File.open(file).each_line {|l|
    parts = l.strip.split(' -> ').map{|a| a.split(',')}
    (parts.length - 1).times.each{|i| 
      max_row = draw_rock(arr, parts[i].map(&:to_i), parts[i+1].map(&:to_i), max_row )
    }
  }

  0.upto(929).each{|j| arr[max_row+2][j] = '#'}

  while true
    res=add_sand(arr, 0, 500)
    if res == SUCCESS
      cnt+=1
    else # res == FAIL
      break
    end
  end

  # part 2
  puts "cnt: #{cnt+1}"
end
part1
