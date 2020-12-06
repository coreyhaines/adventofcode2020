# https://adventofcode.com/2020/day/6
# Declaration forms
# part 1 - Find questions anyone answered yes
# part 2 - Find questions everyone answer yes
require_relative "../shared/loads_entries"
describe "Solving parts of challenge with batch file" do
  it "solves part 1" do
    expect(
      LoadsEntries.from_file("./input.txt")
      .map{find_unique_questions(_1)}
      .map{_1.length}
      .reduce(&:+)
    ).to eq(6170)
  end

  it "solves part 2" do
    expect(
      LoadsEntries.from_file("./input.txt")
      .map{find_common_questions(_1)}
      .map{_1.length}
      .reduce(&:+)
    ).to eq(2947)
  end
end

def find_unique_questions(entry)
  entry
    .gsub(" ", "") # Remove the spaces between the entries
    .split("") # Split out into the questions
    .uniq # Only count once
end

def find_common_questions(entry)
  entry
    .split(" ") # Split into entries
    .map{_1.split("")} # Split each entry into the questions
    .reduce {|accum, entry| accum.intersection(entry) } # Find the intersection of all the entries
end

describe "checking an entry" do
  it "finds the unique questions" do
    entry = "abcx abcy abcz"
    expect(find_unique_questions(entry).length).to eq(6)
  end
end

describe "finding what everyone answered" do
  it "handles two entries" do
    entry = "abc ab"
    expect(find_common_questions(entry)).to match_array(["a", "b"])
  end

  it "handles three entries" do
    entry = "abc ab a"
    expect(find_common_questions(entry)).to match_array(["a"])
  end
end
