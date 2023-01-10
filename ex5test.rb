
DAY=5
ARR = []
ARR << []
ARR << ['Z','N']
ARR << ['M','C','D']
ARR << ['P']


def part1
  #p ARR
  p "***********************************************"
  file="test"
  File.open(file).each_line {|l|
    cnt, from, to = l.strip.split.map(&:to_i)

    puts "(0) #{ARR[from]} #{ARR[to]} #{cnt}"
    ARR[from].pop(cnt).each {|e| ARR[to] << e}
    puts "(1) #{ARR[from]} #{ARR[to]}"
  }
  p ARR
  p ARR.map(&:last).join
end
part1
