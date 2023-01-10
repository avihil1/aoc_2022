
arr = {}; arr.default=0
cnt = 0
File.read('in').each_line {|l|
  l.strip!

  arr[cnt] += l.to_i
  cnt += 1 if l.empty?
}
p arr.values.sort.last(3).reduce(:+)
