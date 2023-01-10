require 'json'
require 'pp'
require 'set'

DAY=25
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2.1008190287.; ru=; session=; _gid=GA1.2..1670089126' > input#{DAY}`
end

#"Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 3 ore and 8 obsidian."

def parse_row(row)
  row.chars
end


def fill_5_arr()
  c = 1
  0.upto(20).each_with_object([]){|i,arr|
    arr << c
    c*=5
  }
end

def agg(arr,num)
  sum_all = 0
  arr.each_with_object([]){|sum, agg_arr|
    sum_all += (num*sum)
    agg_arr << sum_all
  }
end

def dec_to_snafu(dec, arr)
  max_arr = agg(arr,2)
  min_arr = agg(arr,-2)

  snafu = []
  (arr.length-1).downto(1).each{|i|
    found = false
    if dec > 0
      if dec > max_arr[i-1] && dec <= max_arr[i]
        if dec > arr[i] + max_arr[i-1]
          snafu << 2
          dec -= 2*arr[i]
        else # need 1 only
          snafu << 1
          dec -= arr[i]
        end
        found = true
      end
    elsif dec < 0 
      if dec >= min_arr[i] && dec < min_arr[i-1]
        if dec < (-1 * arr[i] + min_arr[i-1])
          snafu << '='
          dec += 2*arr[i]
        else
          snafu << '-'
          dec += arr[i]
        end
        found = true
      end
    end # 0 

    snafu << 0 if !found    
  }
  snafu << (dec >=0 ? dec : dec == -1 ? '-' : '=')
end

def snafu_to_decimal(chs,arr)
  dec = 0
  idx = 0
  cc = chs.dup
  h = {'-' => -1, '=' => -2, '0' => 0, '1' => 1, '2' => 2}
  while char = chs.pop
    dec += h[char]*arr[idx]
    idx+=1
  end 
  puts "[#{cc.join}] #{dec}"
  dec
end

def part1
  file=ARGV[0] || "input#{DAY}"
  arr = []
  arr=fill_5_arr()
  dec = 0
  sum = 0
  File.open(file).each_line {|l|
    num = parse_row(l.strip)
    dec = snafu_to_decimal(num,arr)
    sum += dec
  }

  puts "sum: #{sum}"
  snafu = dec_to_snafu(sum, arr)
  puts "snafu: #{snafu.join}"

end
part1
