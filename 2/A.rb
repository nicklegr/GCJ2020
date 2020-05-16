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

def sum_odd(a, b)
  raise if !a.odd? || !b.odd?
  return 0 if a > b

  a_n = (a-1)/2
  b_n = (b+1)/2

  (b_n ** 2) - (a_n ** 2)
end

def sum_even(a, b)
  raise if !a.even? || !b.even?
  return 0 if a > b

  a_n = a/2
  b_n = (b+2)/2

  b_n*(b_n-1) - a_n*(a_n-1)
end

def test
  a = 110
  b = 100

  puts "init: #{a} #{b}"

  i = 1
  loop do
    str = ""
    if a == b || a > b
      str = "*"
      a -= i
    else
      str = "."
      b -= i
    end

    puts "#{a} #{b} #{str} #{i}"

    i += 1

    break if a < i && b < i
  end
end

# test()
# exit

# main
t_start = Time.now

cases = readline().to_i

(1 .. cases).each do |case_index|
  l, r = ris

putsd "init: #{l} #{r}"

  diff = [l, r].max - [l, r].min

  first = nil
  sum = nil
  if diff > 0
    first = (1..diff).bsearch do |n|
      n * (n+1) / 2 > diff
    end
    if !first
      first = 1
    else
      first -= 1
    end

    sum = first * (first+1) / 2

    if l >= r
      l -= sum
    else
      r -= sum
    end
  else
    first = 0
  end

putsd "first: idx: #{first}, sum: #{sum}"
putsd "now: #{l} #{r}"

  start = first + 1
  if l < start && r < start
    puts "Case ##{case_index}: #{first} #{l} #{r}"
    next
  end

  swap = false
  if l < r
    l, r = r, l
    swap = true
  end

  ans_n = nil
  ans_l = nil
  ans_r = nil
  if start.odd?
    # l: odd, r: even
    n = (0..l).bsearch do |i|
      v = 2*i + 1
      sum_odd(start, v) > l
    end
    l_max_v = 
      if n
        n = n-1
        2*n + 1
      else
        0
      end
    l_sum =
      if n
        sum_odd(start, l_max_v)
      else
        0
      end

    n = (0..r).bsearch do |i|
      v = 2*i
      sum_even(start + 1, v) > r
    end
    r_max_v =
      if n
        n = n-1
        2*n
      else
        0
      end
    r_sum =
      if n
        sum_even(start+1, r_max_v)
      else
        0
      end

    ans_l = l - l_sum
    ans_r = r - r_sum
    ans_n = [l_max_v, r_max_v].max
  else
    # l: even, r: odd
    n = (0..l).bsearch do |i|
      v = 2*i
      sum_even(start, v) > l
    end
    l_max_v =
      if n
        n = n-1
        2*n
      else
        0
      end
    l_sum =
      if n
        sum_even(start, l_max_v)
      else
        0
      end

    n = (0..r).bsearch do |i|
      v = 2*i + 1
      sum_odd(start + 1, v) > r
    end
    r_max_v =
      if n
        n = n-1
        2*n + 1
      else
        0
      end
    r_sum =
      if n
        sum_odd(start+1, r_max_v)
      else
        0
      end

    ans_l = l - l_sum
    ans_r = r - r_sum
    ans_n = [l_max_v, r_max_v].max
  end

  if swap
    puts "Case ##{case_index}: #{ans_n} #{ans_r} #{ans_l}"
  else
    puts "Case ##{case_index}: #{ans_n} #{ans_l} #{ans_r}"
  end
putsd ""

  # # progress
  # trigger = 
  #   if cases >= 10
  #     case_index % (cases / 10) == 0
  #   else
  #     true
  #   end

  # if trigger
  #   STDERR.puts("case #{case_index} / #{cases}, time: #{Time.now - t_start} s")
  # end
end

__END__

1-nの和
  n(n-1) / 2
1 から 2n−1 までの奇数の和
  n^2
2 から 2n-2 までの偶数の和
 n(n-1)

sum 1-101 = 51^2
sum 51-101 = (sum 1-101) - (sum 1-49) = 51^2 - 25^2

差を取り、差の値までで何人さばけるかにぶたん → 多い方からさばく

次にa, bともさばけなければ終了

この後は大きい方から交互にさばくのが確定する
現在のiが奇数
  a == b -> aを偶数の和、bを奇数の和でさばく
  a > b -> aを偶数の和、bを奇数の和でさばく
  a < b -> bを偶数の和、aを奇数の和でさばく
偶数なら逆
