require 'json'
require 'pp'
require 'set'

DAY=18
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2.1008190287.; ru=; session=; _gid=GA1.2.5399308.' > input#{DAY}`
end


def parse_row(row)
  row.split(',').map(&:to_i)
end

def left(x,y,z)
  return 1 if x == 0 
  $arr[x-1][y][z] == 0 ? 1 : 0
end

def right(x,y,z)
  $arr[x+1][y][z] == 0 ? 1 : 0
end

def downy(x,y,z)
  return 1 if y == 0 
  $arr[x][y-1][z] == 0 ? 1 : 0
end

def upy(x,y,z)
  $arr[x][y+1][z] == 0 ? 1 : 0
end

def downz(x,y,z)
  return 1 if z == 0
  $arr[x][y][z-1] == 0 ? 1 : 0
end

def upz(x,y,z)
  $arr[x][y][z+1] == 0 ? 1 : 0
end

def pocket?(x,y,z)
  #puts "#{x} #{y} #{z} #{$arr[x+1][y]}"
  x > 0 && y > 0 && z > 0 && 
  $arr[x+1][y][z] == 1 &&
  $arr[x-1][y][z] == 1 &&
  $arr[x][y+1][z] == 1 &&
  $arr[x][y-1][z] == 1 &&
  $arr[x][y][z+1] == 1 &&
  $arr[x][y][z-1] == 1 
end

def fill_lava_dfs(x,y,z)
  #puts "fill lava #{x},#{y},#{z}"
  if $arr[x][y][z] == 0 # push all around
    $arr[x][y][z] = 2
    if x < ($X-1) && $arr[x+1][y][z] == 0
      #arr << $arr[x+1][y][z]
      fill_lava_dfs(x+1,y,z)
    end
    if x > 0 && $arr[x-1][y][z] == 0
      #arr << $arr[x-1][y][z]
      fill_lava_dfs(x-1,y,z)
    end
    if y < ($Y-1) && $arr[x][y+1][z] == 0
      #arr << $arr[x][y+1][z] 
      fill_lava_dfs(x,y+1,z) 
    end
    if y > 0 && $arr[x][y-1][z] == 0  
      #arr << $arr[x][y-1][z] 
      fill_lava_dfs(x,y-1,z)
    end
    if z < ($Z-1) && $arr[x][y][z+1] == 0
      #arr << $arr[x][y][z+1] 
      fill_lava_dfs(x,y,z+1)
    end
    if  z > 0 && $arr[x][y][z-1] == 0
      fill_lava_dfs(x,y,z-1)
    end
  end
  
end

def count_zeros()
  cnt_all = 0
  0.upto($X-2).each{|x|
    0.upto($Y-2).each{|y|
      0.upto($Z-2).each{|z|
        cnt = 0
        if $arr[x][y][z] == 0
          cnt += 1 if $arr[x+1][y][z] == 1
          cnt += 1 if $arr[x-1][y][z] == 1
          cnt += 1 if $arr[x][y+1][z] == 1
          cnt += 1 if $arr[x][y-1][z] == 1
          cnt += 1 if $arr[x][y][z+1] == 1
          cnt += 1 if $arr[x][y][z-1] == 1 
        end
        cnt_all += cnt
      }
    }
  }
  cnt_all
end

def count_surface()
  cnt_all = 0
  cnt_pockets = 0
  0.upto($X-2).each{|x|
    0.upto($Y-2).each{|y|
      0.upto($Z-2).each{|z|
        if $arr[x][y][z] == 1
          cnt = left(x,y,z) + right(x,y,z) + upy(x,y,z) + downy(x,y,z) + upz(x,y,z) + downz(x,y,z)
          cnt_all += cnt
        #else # 0 - check if it's an air pocket
          #cnt_pockets += pocket?(x,y,z) ? 1 : 0
        end
      }
    }
  }
  cnt_all
end

$X=8
$Y=8
$Z=8
def part1
  file=ARGV[0] || "input#{DAY}"
  h = Hash.new
  idx=0
  max_x, max_y, max_z = [0,0,0]
  File.open(file).each_line {|l|
    x,y,z= parse_row(l.strip)
    idx+=1
    max_x = x if x > max_x
    max_y = y if y > max_y
    max_z = z if z > max_z
  }
  $X = max_x + 3
  $Y = max_y + 3
  $Z = max_z + 3

  $arr = Array.new($X){Array.new($Y){Array.new($Z){0}}}
  File.open(file).each_line {|l|
    x,y,z= parse_row(l.strip)
    $arr[x][y][z] = 1
  }

  # part 1
  puts "#items: #{idx}"
  c1=count_surface()
  puts c1

  # Part 2
  fill_lava_dfs($X-2, $Y-2, $Z-2)
  c2=count_zeros()
  puts c1-c2
end
part1
