require 'json'
require 'pp'
DAY=7
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2.; ru=; session=; _gid=' > input#{DAY}`
end

def calc_sum(h)
  if h[:type] == 'file'
    return h[:size]
  elsif h[:size] > 0
    return h[:size]
  else
    h[:children].each {|c|
      h[:size] += calc_sum(c)
    }
  end   
  return h[:size]
end

def find_all_under(h, num, arr)
  h[:children].each {|c|
    if c[:type] == 'dir' && c[:size] < num
      arr << c[:size]
    end
    find_all_under(c, num, arr) if !c[:children].nil?
  }
end

def find_the_smallest(h, free, min)
  if h[:type] == 'dir' && h[:size] < min[:min] && h[:size] >= free
    min[:min] = h[:size]
  end
  
  if !h[:children].nil?
    h[:children].each { |c| find_the_smallest(c, free, min)}
  end
end  

def part
  h = {}
  ptr = h
  cur_state = nil
  file="input#{DAY}"
  File.open(file).each_line {|l|
    parts = l.strip.split

    if parts[0] == '$'
      cur_state = nil

      if parts[1] == 'cd'
        part = parts[2]
        if part == '..'
          ptr = ptr[:dad] 
        elsif part == '/'
          h['/'] = {name: part, size: 0, type: 'dir', children: []} if h[part].nil?
          ptr = h['/']
        else 
          ptr[:children] = [] if ptr[:children].nil?
          ptr[:children] << {name: part, type: 'dir', size: 0, children: [], dad: ptr}
          ptr = ptr[:children].last
        end
      elsif parts[1] == 'ls'
        cur_state = 'ls'
      end
    elsif cur_state == 'ls' && parts[0] != 'dir'
      ptr[:children] << {type: 'file', name: parts[1], size: parts[0].to_i, dad: ptr}
    end
  }

  calc_sum(h['/'])
  arr=[]
  find_all_under(h['/'], 100000, arr)
  
  #part2
  min = {min: h['/'][:size]}
  find_the_smallest(h['/'], h['/'][:size]-40000000, min)
  p min
end
part
