# https://adventofcode.com/2020/day/9
# Plugging in your phone
# part 1 - Find how many 1-joltage and 3-joltage differences in adapters
# part 2 - Find how many paths of adapters can go from 0 to your phone
RSpec.describe "Solving with batch file" do
  File.open("./input.txt") do |file|
    lines = file.readlines(chomp: true)
    it "solves part 1" do
      expect(lines
        .map(&:to_i)
        .sort
        .prepend(0) # add in the outlet
        .tap{_1.append(_1.last+3)} # add in the phone (max + 3)
        .each_cons(2) # get consecutive joltages
        .map{_2 - _1} # find differences
        .tally # count how many of each difference
        .yield_self{_1[1] * _1[3]} # find product of 1 and 3
            ).to eq 2312
    end

    it "solves part 2" do
      expect(
        lines
        .map(&:to_i)
        .sort
        .prepend(0) # add in the outlet
        .chunk_while{|a,b| b - a < 3} # split into runs of 1 joltage difference
        .map{_1.length} # find the lengths of these runs
        .map{path_count(_1)} # convert to how many paths through it
        .reduce(&:*) # multiple them
      ).to eq 12089663946752
    end
  end
end

def path_count(length)
  case length
  when 1
    1
  when 2
    1
  when 3
    2
  when 4
    4
  when 5
    7
  else
    0
  end
end

def example_data
  [
    16,
    10,
    15,
    5,
    1,
    11,
    7,
    19,
    6,
    12,
    4
  ].sort
end
def example_data_small
  [
    1,
    2,
    4,
    5,
    6
  ].sort
end

def example_data_large
  [
    28,
    33,
    18,
    42,
    31,
    14,
    46,
    20,
    48,
    47,
    24,
    23,
    49,
    45,
    19,
    38,
    39,
    11,
    1,
    32,
    25,
    35,
    8,
    17,
    7,
    9,
    4,
    2,
    34,
    10,
    3
  ].sort
end
