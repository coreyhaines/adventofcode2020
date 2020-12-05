# https://adventofcode.com/2020/day/5
# Find seats
# part 1 - Find max seat code
# part 2 - Find my seat, the missing one
describe "Solving parts of challenge with batch file" do
  it "solves part 1" do
    File.open("./input.txt") do |file|
      seats = file.readlines(chomp: true)
      expect(seats.map {|seat| seat_code(seat)}.max).to eq(901)
    end
  end

  it "solves part 2" do
    File.open("./input.txt") do |file|
      seats = file.readlines(chomp: true)
      seat_codes = seats.map{|seat| seat_code(seat)}
      my_seat = 0
      seat_codes.sort.each_cons(2) do |a, b|
        if b - a > 1 then
          my_seat = a + 1
          break
        end
      end
      expect(my_seat).to eq(661)
    end
  end
end

# Solves the binary string -> number in two different ways, because ¯\_(ツ)_/¯
def seat_code(representation)
  # First method is the most straightforward, since Ruby has easy parsing capabilities
  representation.tr("FBLR", "0101").to_i(2)

  # Second method manual converts binary to decimal
  #representation
    #.reverse # When calculating, need to go from right to left
    #.each_char # Split into the chars
    #.map{ ["B","R"].include?(_1) ? 1 : 0 } # Convert them into 1s and 0s
    #.each_with_index # Keep track of the position
    #.map{|bit, index| bit * 2**index } # Convert to value based on position
    #.reduce(&:+) # Add them all up
end

describe "Interpreting the seat instructions" do
  it "can calculate the seat id" do
    expect(seat_code("FBFBBFFRLR")).to eq(357)
    expect(seat_code("BFFFBBFRRR")).to eq(567)
    expect(seat_code("FFFBBBFRRR")).to eq(119)
    expect(seat_code("BBFFBBFRLL")).to eq(820)
  end
end
