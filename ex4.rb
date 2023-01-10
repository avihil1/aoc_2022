

def contains?(n1, n2)
  n1[0] <= n2[0] && n1[1] >= n2[1]
end

def starts_in?(n1, n2)
  n1[0] < n2[0] && n2[0] <= n1[1]
end

def overlap?(n1,n2)
  contains?(n1, n2)  ||
  contains?(n2, n1)  ||
  starts_in?(n1, n2) ||
  starts_in?(n2, n1)
end

def part
  sum=0
  File.open('input4').each_line{|l|
    l.strip! 
    
    n1, n2 = l.split(',').map{|e| e.split('-').map(&:to_i)}
    sum += 1 if overlap?(n1, n2)
  }
  puts sum
end
part
