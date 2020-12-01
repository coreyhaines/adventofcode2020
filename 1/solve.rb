f = File.read "./input.txt"
total = 2020
size = 3

p f.lines
  .map(&:to_i)
  .combination(size)
  .select{|group| group.sum == total}
  .map{|group| group.reduce(&:*)}
