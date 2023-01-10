require 'set'

def val(c)
  return (c.ord - 'a'.ord + 1)  if 'a'.ord <= c.ord && c.ord <= 'z'.ord
  return (c.ord - 'A'.ord + 27) if 'A'.ord <= c.ord && c.ord <= 'Z'.ord
  return 0
end

def part2
  sum = 0
  f = File.read('input3').split("\n")
  f.each_slice(3) {|s|
    h = {}
    h.default=0
    
    s.each {|ss|
      ss.chars.uniq.each {|c| h[c] += 1}
    }
    c = h.max_by{|k,v| v}[0]
    sum += val(c)
  }
  puts sum
end 
part2

def part1
sum = 0
File.read('input3').each_line {|l|
  l.chop!
  next if l.empty?
  
  s = Set.new
  len = l.length
  l[0..(len-1)/2].chars.each { |c| s << c}

  l[(len/2)..-1].chars.each{|c| 
    if s.include?(c)
      sum += val(c)
      break
    end
  }
}
puts sum
end
