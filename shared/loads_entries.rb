class LoadsEntries
  def self.from_file(filename)
    File.open(filename) do |file|
      from_lines(file.readlines)
    end
  end

  def self.from_lines(lines)
    lines.reduce([""]) do |accum, line|
      if line == "\n" then
        accum[-1].strip!
        accum << ""
      else
        accum[-1] << line.chomp + " "
      end
      accum
    end
  end
end

if Kernel.const_defined?("RSpec")
  RSpec.describe LoadsEntries do
    let(:entry1) {
      ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\n",
       "byr:1937 iyr:2017 cid:147 hgt:183cm\n"]
    }

    let(:entry2) {
      ["hcl:#ae17e1 iyr:2013\n",
       "eyr:2024\n",
       "ecl:brn pid:760753108 byr:1931\n",
       "hgt:179cm\n"]
    }
    context "gathering entries" do
      it "collects a single entry" do
        entries = LoadsEntries.from_lines(entry1)
        expect(entries.length).to eq(1)
        expect(entries.first.split(" ")).to match_array(entry1.join(" ").split(" "))
      end

      it "supports collecting multiple entries" do
        entries = LoadsEntries.from_lines(entry1 + ["\n"] + entry2)
        expect(entries.length).to eq(2)
        expect(entries[0].split(" ")).to match_array(entry1.join(" ").split(" "))
        expect(entries[1].split(" ")).to match_array(entry2.join(" ").split(" "))
      end
    end
  end
end
