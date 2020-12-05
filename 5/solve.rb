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

def seat_code(representation)
  representation.tr("FBLR", "0101").to_i(2)
end

describe "Interpreting the seat instructions" do
  it "can calculate the seat id" do
    expect(seat_code("FBFBBFFRLR")).to eq(357)
    expect(seat_code("BFFFBBFRRR")).to eq(567)
    expect(seat_code("FFFBBBFRRR")).to eq(119)
    expect(seat_code("BBFFBBFRLL")).to eq(820)
  end
end
