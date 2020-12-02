# https://adventofcode.com/2020/day/2
# Specifically, check password policy.
# part 1 - minimum and maximum occurrence
# part 2 - only once at either location
def check_part_1(min_count, max_count, policy_letter, pwd)
  letter_count = pwd.count(policy_letter)
  letter_count >= min_count && letter_count <= max_count
end

def check_part_2(index1, index2, policy_letter, pwd)
  (pwd[index1-1] == policy_letter) ^ (pwd[index2-1] == policy_letter)
end


part_1_count = 0
part_2_count = 0
splitting_regex = /^(\d+)-(\d+) (\w): (\w*)$/

File.read("./input.txt").each_line do |line|
  num1, num2, policy_letter, pwd = line.match(splitting_regex).captures

  num1 = num1.to_i
  num2 = num2.to_i

  if check_part_1(num1, num2, policy_letter, pwd)
    part_1_count += 1
  end

  if check_part_2(num1, num2, policy_letter, pwd)
    part_2_count += 1
  end
end

puts "Part 1: #{part_1_count}"
puts "Part 2: #{part_2_count}"
