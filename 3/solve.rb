# https://adventofcode.com/2020/day/3
# Specifically, calculate how many trees hit on a toboggan run.
# part 1 - over 3, down 1
# part 2 - calculate several trajectories, multiple the results.
def assert(actual, expected)
  if actual == expected
    puts "T"
  else
    puts "F Expected #{expected}, Got #{actual}"
  end
end

def count_trees(map, down, right)
  row = 0
  column = 0
  map.reduce(0) do |count, line|
    if column % down != 0 then # Make sure we are on a row we want to count
      count
    else
      count += 1 if line[row] == "#" # Increment our count if there is a tree in the column
      row = (row+right) % line.length # Move to the right, with edge wrapping
      count
    end.tap{column += 1} # Move down
  end
end

map = File.readlines("input.txt").map{|line| line.chomp.split("") }

part_1_answer = count_trees(map, 1, 3)
puts "Part 1 #{part_1_answer}"
assert(part_1_answer, 209)

part_2_answer = [
  [1, 1],
  [1, 3],
  [1, 5],
  [1, 7],
  [2, 1],
].map{|movement| count_trees(map, movement[0], movement[1])}.reduce(&:*)
puts "Part 2 #{part_2_answer}"
assert(part_2_answer, 1574890240)
