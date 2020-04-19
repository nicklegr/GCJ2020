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

def array_2d(r, c)
  ret = []
  r.times do
    ret << [0] * c
  end
  ret
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

# main
t, a, b = ris
# srand(100)

t.times do
  # find board
  ok = false
  start = nil
  loop do
    x = -10**9 + rand((10**9) * 2)
    y = -10**9 + rand((10**9) * 2)
    puts_sync("#{x} #{y}")
    res = rs
    if res == "CENTER"
      ok = true
ppd "CENTER: #{x} #{y}"
      break
    end
    if res == "HIT"
      ok = true
      start = [x, y]
ppd "HIT start: #{x} #{y}"
      break
    end
  end

  raise if !ok
  next if !start # lucky CENTER

  # find left & right edge
  s_x = start[0]
  s_y = start[1]
  puts_sync("#{s_x + 1} #{s_y}")
  res_r = rs
  puts_sync("#{s_x - 1} #{s_y}")
  res_l = rs

  edge_l = nil
  edge_r = nil
  edge_t = nil
  edge_b = nil
  if res_l == "MISS" && res_r == "MISS"
    # lucky
    edge_l = s_x
    edge_r = s_x
ppd "lucky: #{edge_l} #{edge_r}"
  else
    # find left: MISS -- HIT
    edge_l = ((-10**9)..(s_x)).bsearch do |cx|
      puts_sync("#{cx} #{s_y}")
      rs == "HIT"
    end

    # find right: HIT -- MISS
    edge_r = ((s_x)..(10**9)).bsearch do |cx|
      puts_sync("#{cx} #{s_y}")
      rs == "MISS"
    end
ppd "normal: #{edge_l} #{edge_r}"
  end

  # find bottom: MISS -- HIT
  edge_b = ((-10**9)..(s_y)).bsearch do |cy|
    puts_sync("#{s_x} #{cy}")
    rs == "HIT"
  end

  # find top: HIT -- MISS
  edge_t = ((s_y)..(10**9)).bsearch do |cy|
    puts_sync("#{s_x} #{cy}")
    rs == "MISS"
  end

ppd "y-axis: #{edge_b} #{edge_t}"

  c_x = (edge_l + edge_r) / 2
  c_y = (edge_b + edge_t) / 2
ppd "calc_center: #{c_x}, #{c_y}"

  puts_sync("#{c_x} #{c_y}")
  next if rs == "CENTER"

  raise
end
