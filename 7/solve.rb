# https://adventofcode.com/2020/day/7
# Counting contained bags
# part 1 - Find count of containing bags
# part 2 - Find count of contained bags
describe "Solving parts of challenge with batch file" do
  it "solves part 1" do
    File.open("./input.txt") do |file|
      lines = file.readlines(chomp: true)
      expect(
        lines
        .map{parse_containment(_1)}
        .yield_self{build_containment_graph(_1)}
        .yield_self{find_possible_containing_colors(_1, "shiny gold bag")}
        .length
      ).to eq 128
    end
  end

  it "solves part 2" do
    File.open("./input.txt") do |file|
      lines = file.readlines(chomp: true)
      expect(
        lines
        .map{parse_containment(_1)}
        .yield_self{build_containment_graph(_1)}
        .yield_self{count_contained_bags(_1, "shiny gold bag")}
      ).to eq 20189
    end
  end
end

def find_possible_containing_colors(containment_graph, color)
  contained_in = containment_graph[color][:contained_in]
  ( contained_in + # include the immediate container
   contained_in.map { find_possible_containing_colors containment_graph, _1 } # add in the container's containers
  .flatten).uniq # arrays of arrays of arrays as we walk the graph
end

def count_contained_bags(containment_graph, color)
  contains = containment_graph[color][:contains]
  contains.map(&:first).sum + # count the contained bags
    contains.reduce(0) { |inner_total, (count, contained_color)| # sum up the contained bags' contained bags
    inner_total + count * count_contained_bags(containment_graph, contained_color)
  }
end

def empty_containment_graph
  Hash.new { |hash, key|
    hash[key] = {
      contained_in: [],
      contains: []
    }
  }
end

def build_containment_graph(containments)
  containments.reduce(empty_containment_graph) do |graph, (container, containees)|
    graph[container][:contains] = containees
    containees.map(&:last).each{ graph[_1][:contained_in] << container }
    graph
  end
end

def parse_containment(containment)
  color, contained_bags = containment.split("s contain ")
  [color, parse_contained_bags(contained_bags)]
end

def parse_contained_bags(contained_bags)
  case contained_bags
  when "no other bags."
    []
  else
    contained_bags[0...-1]
      .split(", ")
      .map{ parse_contained_bag(_1) }
  end
end

def parse_contained_bag(contained_bag)
  count, _, rest = contained_bag.partition(" ")
  [
    count.to_i,
    rest.delete_suffix("s")
  ]
end

describe "parsing entries" do
  it "handles when a bag does not contain other bags" do
    containment = "faded blue bags contain no other bags."
    expect(parse_containment(containment)).to eq(["faded blue bag", []])
  end

  it "handles when a bag contains a single other bag" do
    containment = "bright white bags contain 1 shiny gold bag."
    expect(parse_containment(containment)).to eq(["bright white bag", [[1, "shiny gold bag"]]])
  end

  it "handles when a bag contains more than one of a single other bag" do
    containment = "bright white bags contain 2 shiny gold bags."
    expect(parse_containment(containment)).to eq(["bright white bag", [[2, "shiny gold bag"]]])
  end

  it "handles when a bag contains two others bags" do
    containment = "light red bags contain 1 bright white bag, 2 muted yellow bags."
    expect(parse_containment(containment)).to eq(["light red bag", [[1, "bright white bag"], [2, "muted yellow bag"]]])
  end

  it "handles a line from input" do
    containment = "dotted lime bags contain 4 dull tomato bags, 5 dull yellow bags, 4 shiny gold bags."
    expect(parse_containment(containment)).to eq(["dotted lime bag", [[4, "dull tomato bag"], [5, "dull yellow bag"], [4, "shiny gold bag"]]])
  end
end

describe "building containment graph" do
  it "does not mark a bag if no containment" do
    containment = [ ["faded blue bag", [] ] ]
    expect(build_containment_graph(containment)["faded blue bag"]).to match(
      { contained_in: [],
        contains: [] }
    )
  end

  it "marks a bag that is contained in another bag" do
    containment = [ ["faded blue bag", [[1, "shiny gold bag"]] ] ]
    graph = build_containment_graph(containment)
    expect(graph["shiny gold bag"]).to match(
      { contained_in: ["faded blue bag"],
        contains: [] }
    )
    expect(graph["faded blue bag"]).to match(
      { contained_in: [],
        contains: [[1, "shiny gold bag"]] }
    )
  end

  it "constructs a node with multiple contained bags" do
    containment = [ ["faded blue bag", [[1, "shiny gold bag"], [2, "bright white bag"] ] ]]
    expect(build_containment_graph(containment)).to match(
      { "shiny gold bag" => {contained_in: ["faded blue bag"], contains: []},
        "bright white bag" => {contained_in: ["faded blue bag"], contains: []},
        "faded blue bag" => {contained_in: [], contains: [[1, "shiny gold bag"], [2, "bright white bag"]]}
    }
    )
  end

  it "constructs from multiple containment descriptions" do
    containment = [
      ["faded blue bag", [[1, "shiny gold bag"], [2, "bright white bag"]] ],
      ["vibrant plum bag", [[3, "shiny gold bag"]] ]
    ]
    expect(build_containment_graph(containment)).to match(
      { "shiny gold bag" => {contained_in: ["faded blue bag", "vibrant plum bag"], contains: []},
        "faded blue bag" => {contained_in: [], contains: [[1, "shiny gold bag"], [2, "bright white bag"]]},
        "vibrant plum bag" => {contained_in: [], contains: [[3, "shiny gold bag"]]},
        "bright white bag" => {contained_in: ["faded blue bag"], contains: []}
    }
    )

  end
end

context "Walking the graph" do
  let(:containment_graph) {
    {
      "muted yellow bag" => {contained_in: ["light red bag", "dark orange bag"], contains: [[1, "faded blue bag"]]},
      "faded blue bag" =>   {contained_in: ["muted yellow bag", "dark olive bag"], contains: []},
      "dark orange bag" =>  {contained_in: [], contains: [[2, "muted yellow bag"]]},
      "light red bag" =>    {contained_in: [], contains: [[3, "muted yellow bag"]]},
      "dark olive bag" =>   {contained_in: ["striped lime bag"], contains: [[2, "faded blue bag"]]},
      "striped lime bag" => {contained_in: [], contains: [[2,"dark olive bag"]]},
    }
  }
  describe "finding possible containing colors" do
    it "traces a single step" do
      expect(find_possible_containing_colors(containment_graph, "muted yellow bag")).to match_array(["light red bag", "dark orange bag"])
    end

    it "traces more steps" do
      expect(find_possible_containing_colors(containment_graph, "faded blue bag")).to match_array(["muted yellow bag", "dark olive bag", "light red bag", "dark orange bag", "striped lime bag"])
    end
  end

  describe "counting contained bags" do
    it "traces a single step" do
      expect(count_contained_bags(containment_graph, "dark olive bag")).to eq(2)
    end

    it "traces more steps" do
      expect(count_contained_bags(containment_graph, "striped lime bag")).to eq(2 + 2*2)
    end
  end
end
