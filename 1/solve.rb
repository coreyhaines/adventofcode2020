# https://adventofcode.com/2020/day/1
# Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.
# Find three numbers in your expense report that meet the same criteria.

f = File.read "./input.txt"
total = 2020
size = 3

p f.lines # Read the numbers from the file
  .map(&:to_i) # Convert them to integers
  .combination(size) # Get all combinations of :size: groups
  .select{|group| group.sum == total} # Find the group that sums to the :total:
  .map{|group| group.reduce(&:*)} # Find the product of the group
