require 'pp'

def ppd(*arg)
  if $DEBUG
    arg.each do |e|
      PP.pp(e, STDERR)
    end
  end
end

def putsd(*arg)
  if $DEBUG
    STDERR.puts(*arg)
  end
end

def parrd(arr)
  putsd arr.join(" ")
end

def ri
  readline.to_i
end

def ris
  readline.split.map do |e| e.to_i end
end

def rs
  readline.chomp
end

def rss
  readline.chomp.split
end

def rf
  readline.to_f
end

def rfs
  readline.split.map do |e| e.to_f end
end

def rws(count)
  words = []
  count.times do
    words << readline.chomp
  end
  words
end

def puts_sync(str)
  puts str
  STDOUT.flush
end

class Integer
  def popcount32
    bits = self
    bits = (bits & 0x55555555) + (bits >>  1 & 0x55555555)
    bits = (bits & 0x33333333) + (bits >>  2 & 0x33333333)
    bits = (bits & 0x0f0f0f0f) + (bits >>  4 & 0x0f0f0f0f)
    bits = (bits & 0x00ff00ff) + (bits >>  8 & 0x00ff00ff)
    return (bits & 0x0000ffff) + (bits >> 16 & 0x0000ffff)
  end

  def combination(k)
    self.factorial/(k.factorial*(self-k).factorial)
  end

  def permutation(k)
    self.factorial/(self-k).factorial
  end

  def factorial
    return 1 if self == 0
    (1..self).inject(:*)
  end
end

def array_2d(r, c)
  ret = []
  r.times do
    ret << [0] * c
  end
  ret
end

$ans = nil

def solve(mat, n, cur_r, cur_c, trace)
# ppd mat
  if cur_r == n
    sum = 0
    for i in 0...n
      sum += mat[i][i]
    end
    if sum == trace
      $ans = mat
      return true
    end
    return false
  end

  mask = (1 << n) - 1
  for r in 0...cur_r
    mask &= ~(1 << (mat[r][cur_c]-1))
  end
  for c in 0...cur_c
    mask &= ~(1 << (mat[cur_r][c]-1))
  end

  for i in 0...n
    next if ((mask >> i) & 1) == 0

    mat[cur_r][cur_c] = i + 1

    next_r = cur_r
    next_c = cur_c

    next_c += 1
    if next_c == n
      next_c = 0
      next_r += 1
    end

    if solve(mat, n, next_r, next_c, trace)
      return true
    end
  end
  return false
end

# main
t_start = Time.now

cases = readline().to_i

(1 .. cases).each do |case_index|
  n, k = ris

# n = 5
# for k in n .. n**2
#   case_index = k

  $ans = nil
  mat = array_2d(n, n)
# ppd mat
  solve(mat, n, 0, 0, k)
# ppd $ans

  if $ans
    puts "Case ##{case_index}: POSSIBLE"
    for r in 0...n
      puts mat[r].join(" ")
    end
  else
    puts "Case ##{case_index}: IMPOSSIBLE"
  end

  # progress
  trigger = 
    if cases >= 10
      case_index % (cases / 10) == 0
    else
      true
    end

  if trigger
    STDERR.puts("case #{case_index} / #{cases}, time: #{Time.now - t_start} s")
  end
end
