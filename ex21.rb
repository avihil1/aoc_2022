require 'json'
require 'pp'
require 'set'

DAY=21
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2.1008190287.1669061645; ru=; session=; _gid=GA1.2.5399308.1670089126' > input#{DAY}`
end

def parse_row(row)
  monkey, op = row.split(':')
  h = {}
  if op.to_i > 0
    h[:num] = op.to_i
  else
    ['+','-','*','/'].each {|oper|
      if !op[oper].nil?
        m1, m2 = op.split(oper).map(&:strip)
        h = {op: oper, m1: m1, m2: m2}
        break
      end
    }
  end
  [monkey, h]
end

def yell(hsh, monkey)
  if hsh[monkey][:num]
    hsh[monkey][:res] = hsh[monkey][:num]
    return hsh[monkey][:num]
  else
    case hsh[monkey][:op]
    when '+'
      res = yell(hsh, hsh[monkey][:m1]) + yell(hsh, hsh[monkey][:m2])
      hsh[monkey][:res] = res
      return res
    when '-'
      res = yell(hsh, hsh[monkey][:m1]) - yell(hsh, hsh[monkey][:m2])
      if monkey == "ptdq"
        ;#puts "==== res: #{res} #{monkey}"
      end
      hsh[monkey][:res] = res
      return res
    when '*'
      res = yell(hsh, hsh[monkey][:m1]) * yell(hsh, hsh[monkey][:m2])
      hsh[monkey][:res] = res
      return res
    when '/'
      res = yell(hsh, hsh[monkey][:m1]) / yell(hsh, hsh[monkey][:m2])
      hsh[monkey][:res] = res
      return res
    when '='
       #puts "= #{monkey}"
       return yell(hsh, hsh[monkey][:m1]) == yell(hsh, hsh[monkey][:m2]) ? 1 : 0
    end
  end
end

def part1
  file=ARGV[0] || "input#{DAY}"
  hsh = Hash.new
  idx=0
  File.open(file).each_line {|l|
     monkey, h = parse_row(l.strip)
     hsh[monkey] = h
     idx += 1
  }

  # part 1
  puts "#items: #{idx}"
  puts yell(hsh, "root")

  puts "Part2"
  # part 2
  hsh["root"][:op] = '='
  i = 3403989691757
  add = 100000
  multi = 2
  m2 = hsh[ hsh["root"][:m2] ][:res]
  while true
    hsh["humn"][:num] = i
    yell(hsh,"root")
    m1 = hsh[ hsh["root"][:m1] ][:res]
    puts "#{i} #{m1}"
    if m1 < m2
      puts "----> #{i} #{m1} <> #{m2} #{add}"
      i -= add
      add /= 10 if add > 9
    end
    if m1 == m2
      puts i
      puts "m1: #{m1}, m2: #{m2}"
      break
    end
    i += add
  end
  
end
part1
