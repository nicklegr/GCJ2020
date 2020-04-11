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

def ones(r)
  return 0 if r == 1
  return (r-1)*2 - 1
end

# main
t_start = Time.now

cases = readline().to_i

(1 .. cases).each do |case_index|
  n = ri

  v = n
  arr = []
  last_factor = nil
  loop do
    break if v == 0

    30.downto(0) do |i|
      # diff
      diff = 
        if !last_factor
          0
        else
          last_factor - i - 1
        end

      next if diff < 0

      if v <= diff
        if last_factor
          raise "diff = #{diff}, v = #{v}, ones = #{ones(last_factor + 1)}" if v > ones(last_factor + 1)
        end
        v = 0
        arr << {"move" => diff}
        break
      end

      if v >= 2 ** i + diff
        if diff != 0
          v -= diff
          raise if v < 0
          arr << {"move" => diff}
        end
        v -= 2 ** i
        arr << {"factor" => i}
        last_factor = i
        break
      end
    end
    # ppd arr
    # ppd v
  end

  puts "Case ##{case_index}:"

  cur_r = nil
  cur_c = 1
  arr.each do |e|
    if e["factor"]
      factor = e["factor"] + 1
      next_r = nil
      if !cur_r
        cur_r = factor
        next_r = factor
      else
        next_r = factor
        raise if next_r >= cur_r
      end

      # move to current row
      (cur_r - 1).downto(next_r + 1) do |i|
        cur_c -= 1 if cur_c != 1
        puts "#{i} #{cur_c}"
      end

      # trace row
      if cur_c == 1
        for c in 1..next_r
          puts "#{next_r} #{c}"
        end
        cur_c = next_r
      else
        cur_c.downto(1) do |c|
          puts "#{next_r} #{c}"
        end
        cur_c = 1
      end
    elsif e["move"]
      raise if !cur_r
      raise if !cur_c

      diff = e["move"]
      diff.times do
        cur_r -= 1
        cur_c -= 1 if cur_c != 1
        puts "#{cur_r} #{cur_c}"
      end
    else
      raise
    end
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

__END__

# for n in 1..30
#   puts "#{n}: #{2**n} #{((n-1)*2 - 1)}"
# end

for n in 1000000..2000000
  # puts "#{n} -- "

  v = n
  arr = []
  last_factor = nil
  loop do
    break if v == 0

    30.downto(0) do |i|
      # diff
      diff = 
        if !last_factor
          0
        else
          last_factor - i - 1
        end

      next if diff < 0

      if v <= diff
        if last_factor
          raise "diff = #{diff}, v = #{v}, ones = #{ones(last_factor + 1)}" if v > ones(last_factor + 1)
        end
        v = 0
        arr << [1] * diff
        break
      end

      if v >= 2 ** i + diff
        if diff != 0
          v -= diff
          raise if v < 0
          arr << [1] * diff
        end
        v -= 2 ** i
        arr << 2 ** i
        last_factor = i
        break
      end
    end
    # ppd arr
    # ppd v
  end

  raise if arr.flatten.inject(:+) != n
  puts "#{n} = #{arr.join("+")}"
end
