require 'json'
require 'pp'
require 'set'
DAY=11
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'cookie: _ga=GA1.2..1669061645; ru=; session=; _gid=GA1.2.1670089126' > input#{DAY}`
end

$DIV=1
class Monkey
  attr_accessor :func, :num, :items, :div, :cond, :count

  def add(item); @items << item; end
  def add_division(div); @div = div; end
  def add_condition(cond, monkey); @cond[cond] = monkey; end
  def items?; !items.empty?; end
  #def items?; !items[@ptr].nil?; end

  def initialize(num)
    @num = num
    @items = []
    @cond = {}
    @count = 0
  end

  def apply(action, num1, num2)
    if action == '+'
      return num1+num2
    else # '*'
      return num1*num2
    end
  end

  def calc_new_worry(arr)
    left, what, right = arr
    @action = what

    right_i = right.to_i
    left_i  =  left.to_i
    left =  left  == "old"
    right = right == "old"
    
    @func = lambda{|worry| apply(what, (left ? worry : left_i), (right ? worry : right_i))} 
  end


  def inspect
    item = items.shift#[@ptr]
    item = @func.call(item)
    item %= $DIV 
    #item /= 3
    @count += 1
    return [item, @cond[( (item % @div)==0 ).to_s]]
  end
end

def part
  h = {}
  file="input#{DAY}"
  m = nil
  num = 0
  File.open(file).each_line {|l|
    parts = l.strip.split

    if parts[0] == 'Monkey'
      num = parts[1].to_i
      m = Monkey.new(num)
      h[num] = m
    end

    if parts[0] == 'Starting'
      parts.shift(2)
      parts.map(&:to_i).each { |item| m.add(item) }
    end

    m.calc_new_worry(parts[-3..-1])     if parts[0] == 'Operation:'
    m.add_division(parts.last.to_i)     if parts[0] == 'Test:'
    m.add_condition(parts[1].sub(':',''), parts.last.to_i) if parts[0] == 'If' 
   
  }
  h[num] = m
  h.values.map{|a| $DIV *= a.div}
  puts num

  # Inspect
  rounds=10000
  rounds.times.each {|_|
    (num+1).times.each {|i|
      while h[i].items?
        item, monkey = h[i].inspect
        h[monkey].add(item)
      end
    }
  }

  p h.values.map{|a| a.count}.sort.last(2).reduce(:*)

end
part
