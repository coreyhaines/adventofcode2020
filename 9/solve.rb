# https://adventofcode.com/2020/day/9
# Encoding Error
# part 1 - a pair in list of 25 numbers add up to 26
# part 2 - find first n contiguous digits that don't add up to part 1 solution
File.open("./input.txt") do |file|
  lines = file.readlines(chomp: true).map(&:to_i)

  part_1_solution = 0

  # Part 1: 15690279
  lines.each_cons(26) do |numbers|
    if numbers[0...-1]
      .combination(2)
      .map(&:sum)
      .none?{_1 == numbers[-1]}
    part_1_solution = numbers[-1]
    break
    end
  end
  puts "Part 1: #{part_1_solution}"

  part_2_solution = 0
  # Part 2: 2174232
  (2..lines.length).each do |contiguous_length|
    solution = lines
      .each_cons(contiguous_length)
      .find{_1.sum == part_1_solution}
    unless solution.nil?
      part_2_solution = solution.minmax.sum
      break
    end
  end
  puts "Part 2: #{part_2_solution}"
end
