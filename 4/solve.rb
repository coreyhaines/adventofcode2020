# https://adventofcode.com/2020/day/4
# Validate Passports
# part 1 - check required fields
# part 2 - validate fields
describe "Solving parts of challenge with batch file" do
  it "solves part 1" do
    lines = File.open("./input.txt").readlines
    expect(collect_entries(lines)
      .map{parse_fields(_1)}
      .map{check_missing_keys(_1)}
      .select(&:itself)
      .length).to eq(219)
  end

  it "solves part 2" do
    lines = File.open("./input.txt").readlines
    expect(collect_entries(lines)
      .map{parse_fields(_1)}
      .select{check_missing_keys(_1)}
      .select{check_formats(_1)}
      .length).to eq(127)
  end
end

def collect_entries(lines)
  lines.reduce([""]) do |accum, line|
    if line == "\n" then
      accum[-1].strip!
      accum << ""
    else
      accum[-1] << line + " "
    end
    accum
  end
end

def parse_fields(line)
  line
    .split(" ")
    .map {|entry| entry.split(":")}
    .to_h
end

def parse_entries(lines)
  collect_entries(lines)
    .map{|entry| parse_fields(entry) }
end

REQUIRED_FIELDS = [
  "byr", # (Birth Year)
  "iyr", # (Issue Year)
  "eyr", # (Expiration Year)
  "hgt", # (Height)
  "hcl", # (Hair Color)
  "ecl", # (Eye Color)
  "pid", # (Passport ID)
  "cid"  # (Country ID)
]

ACCEPTABLE_EYE_COLORS = [
  "amb",
  "blu",
  "brn",
  "gry",
  "grn",
  "hzl",
  "oth"
]

def check_missing_keys(passport)
  missing_keys = (REQUIRED_FIELDS - passport.keys)
  missing_keys.empty? || missing_keys == ["cid"]
end

def check_height(height)
  if height.end_with?("cm") then
    height[0...-2].to_i.between?(150, 193)
  elsif height.end_with?("in") then
    height[0...-2].to_i.between?(59, 76)
  else
    false
  end
end

def check_eye_color(eye_color)
  ACCEPTABLE_EYE_COLORS.include?(eye_color)
end

def check_hair_color(hair_color)
  hair_color.match?(/^#[0-9a-f]{6}$/)
end

def check_passport_number(passport_number)
  passport_number.length == 9
end

def check_formats(passport)
  (passport["byr"].length == 4 && passport["byr"].to_i.between?(1920, 2002)) &&
    (passport["iyr"].length == 4 && passport["iyr"].to_i.between?(2010, 2020)) &&
    (passport["eyr"].length == 4 && passport["eyr"].to_i.between?(2020, 2030)) &&
    check_height(passport["hgt"]) &&
    check_hair_color(passport["hcl"]) &&
    check_eye_color(passport["ecl"]) &&
    check_passport_number(passport["pid"])
end

describe "Building pieces" do

  let(:valid_passport) {
    ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
     "byr:1937 iyr:2017 cid:147 hgt:183cm"]
  }

  let(:northpole_passport) {
    ["hcl:#ae17e1 iyr:2013",
     "eyr:2024",
     "ecl:brn pid:760753108 byr:1931",
     "hgt:179cm"]
  }

  let(:invalid_passports) {
    [["iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
     "hcl:#cfa07d byr:1929"],

     ["hcl:#cfa07d eyr:2025 pid:166559648",
     "iyr:2011 ecl:brn hgt:59in"]]
  }

  describe "entry validations for part 2" do
    context "validating height" do
      it "requires a unit" do
        expect(check_height("190")).to eq(false)
      end

      [149, 194].each do |height|
        it "checks cm out of bounds #{height}" do
          expect(check_height("#{height}cm")).to eq(false)
        end
      end
      [150, 175, 193].each do |height|
        it "checks cm in bounds #{height}" do
          expect(check_height("#{height}cm")).to eq(true)
        end
      end

      [58, 77].each do |height|
        it "checks inches out of bounds {#height}" do
          expect(check_height("#{height}in")).to eq(false)
        end
      end

      [59, 70, 76].each do |height|
        it "checks inches of bounds {#height}" do
          expect(check_height("#{height}in")).to eq(true)
        end
      end
    end

    context "validating hair color" do
      it "supports hex rgb" do
        expect(check_hair_color("#zzzzzz")).to eq(false)
        expect(check_hair_color("#11ff11")).to eq(true)
      end
    end

    context "validating eye color" do
      it "does not accept non-acceptable eye color" do
        expect(check_eye_color("BAD_COLOR")).to eq(false)
      end

      ACCEPTABLE_EYE_COLORS.each do |eye_color|
        it "accepts #{eye_color}" do
          expect(check_eye_color(eye_color)).to eq(true)
        end
      end
    end

    context "validating passport number" do
      it "requires nine digits" do
        expect(check_passport_number("0123456789")).to eq(false)
        expect(check_passport_number("000000001")).to eq(true)
      end
    end
  end


  context "parsing fields" do
    it "separates into name-values" do
      fields = parse_fields("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd")
      expect(fields).to match({"ecl" => "gry", "pid" => "860033327", "eyr" => "2020", "hcl" => "#fffffd"})
    end
  end

  context "gathering entries" do
    it "collects a single entry" do
      entries = collect_entries(valid_passport)
      expect(entries.length).to eq(1)
      expect(entries.first.split(" ")).to match_array(valid_passport.join(" ").split(" "))
    end

    it "supports collecting multiple entries" do
      entries = collect_entries(valid_passport + ["\n"] + northpole_passport)
      expect(entries.length).to eq(2)
      expect(entries[0].split(" ")).to match_array(valid_passport.join(" ").split(" "))
      expect(entries[1].split(" ")).to match_array(northpole_passport.join(" ").split(" "))
    end
  end

  context "gathering and converting" do
    it "can convert a list of entries into list of name-value" do
      entries = parse_entries(valid_passport + ["\n"] + northpole_passport)
      expect(entries[0].keys).to match_array(["ecl", "pid", "eyr", "hcl", "byr", "iyr", "cid", "hgt"])
      expect(entries[1].keys).to match_array(["hcl", "iyr", "eyr", "ecl", "pid", "byr", "hgt"])
    end
  end

  context "recognizing validity" do
    it "passes if all fields there" do
      entry  = parse_entries(valid_passport)
      expect(check_missing_keys(entry.first)).to be(true)
    end
    it "fails if fields missing" do
      entries  = parse_entries(invalid_passports[0] + ["\n"] + invalid_passports[1])
      expect(check_missing_keys(entries[0])).to be(false)
      expect(check_missing_keys(entries[1])).to be(false)
    end
    it "passes if cid is only one missing" do
      entry  = parse_entries(northpole_passport)
      expect(check_missing_keys(entry.first)).to be(true)
    end
  end
end


