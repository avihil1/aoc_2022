
DAY=5
if !File.exists?("input#{DAY}")
`curl 'https://adventofcode.com/2022/DAY/#{DAY}/input' -H'cookie: _ga=; ru=; session=' > input#{DAY}`
end


ARR = []
ARR << []
ARR << ['B','Z','T']
ARR << ['V','H','T','D','N']
ARR << ['B','F','M','D']
ARR << ['T','J','G','W','V','Q','L']
ARR << ['W','D','G','P','V','F','Q','M']
ARR << ['V','Z','Q','G','H','F','S']
ARR << ['Z','S','N','R','L','T','C','W']
ARR << ['Z','H','W','D','J','N','R','M']
ARR << ['M','Q','L','F','D','S']


def part
  #p ARR
  p "***********************************************"
  file="input#{DAY}"
  File.open(file).each_line {|l|
    cnt, from, to = l.strip.split.map(&:to_i)
    ARR[from].pop(cnt).each {|e| ARR[to] << e} # reverse for part1
  }
  p ARR.map(&:last).join
end
part
