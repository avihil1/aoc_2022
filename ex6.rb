
DAY=6
if !File.exists?("input#{DAY}")
cookie='cookie: _ga=; ru=; session=; _gid=; _gat=1'
`curl 'https://adventofcode.com/2022/day/#{DAY}/input' -H'#{cookie}' > input#{DAY}`
end



def part(s, e)
  file="input#{DAY}"
  File.open(file).each_line {|l|
    cs = l.strip.chars
   
    while true 
      if cs[s..e].uniq.length == cs[s..e].length
        puts (e+1)
        break
      end
      s+=1
      e+=1
    end
  }
end
part(0,13)
