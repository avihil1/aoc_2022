require 'json'
require 'pp'
require 'set'

DAY=15
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2.; ru=; session=; _gid=GA1.2.5399308.' > input#{DAY}`
end

#https://en.wikipedia.org/wiki/Taxicab_geometry
def calc_dist(a, b); (a[0]-b[0]).abs + (a[1]-b[1]).abs; end

def g(x,y); "#{x},#{y}"; end
def find_no_beacon(sensor, beacon, dist, set, y)
  start_x = sensor[0] - dist
  max_x   =  sensor[0] + dist

  start_x.upto(max_x).each {|x| 
    set << g(x,y) if dist >= calc_dist(sensor, [x,y])
  }
end

def to_arr(bds, place)
  bds[place] ? bds[place].map{|e| [e[1],e[1]]} : []
end

def beacon_left(arr)
  arr.sort!{|(x1,y1),(x2,y2)| x1<=>x2}
  s,e = arr[0]
  arr.each {|(x_start, x_end)|
    return (e+1) if x_start > (e+1)
    e = x_end    if x_end > e
  }
  return $max_x if e < $max_x
end

# arr -> [[beacon, dist], ...]
# bds -> {0: [[beacon], [sensor], [beacon]]}
def find_beacon(arr, bds)
  0.upto($max_y).each {|y|
    temp_arr = []
    # mark impossible row=y
    arr.each {|(b_x,b_y), dist|
      x_diff = dist - (b_y - y).abs
      next if x_diff < 0 # too far from this sensor
      x_start = [0,      b_x-x_diff].max
      x_end   = [$max_x, b_x+x_diff].min

      temp_arr << [x_start, x_end]
    }
    temp_arr |= to_arr(bds, y)

    if x=beacon_left(temp_arr)
      puts ">>>>>>>>>>>>> #{x*$max_x+y} <<<<<<<<<<<<<<"
      break
    end
  }
end

$max_x=$max_y=20
def part1
  blocked = Set.new
  file=ARGV[0] || "input#{DAY}"
  bs = Set.new
  y = 10
  if file == "input#{DAY}"
    y = 2000000
    $max_x=$max_y=4000000
  end
  arr = []
  bds = {}
  File.open(file).each_line {|l|
    sensor, beacon = l.strip.split('at').map{|a| a.split(',').map{|a| a.sub('x=','').sub('y=','').to_i}}
    bs << g(sensor[0], sensor[1]) if sensor[1] == y 
    bs << g(beacon[0], beacon[1]) if beacon[1] == y
    dist = calc_dist(sensor, beacon)
    find_no_beacon(sensor, beacon, dist, blocked, y)

    # Part2 
    bds[sensor[1]] = [] if bds[sensor[1]].nil?
    bds[beacon[1]] = [] if bds[beacon[1]].nil?

    bds[sensor[1]] << sensor
    bds[beacon[1]] << beacon
    bds[beacon[1]].uniq!

    arr << [sensor,dist] 
  }

  #Part 2
  find_beacon(arr, bds)

  # part 1
  puts "cnt: #{blocked.length-bs.length} | #{bs.length}"
end
part1
