describe "Solving parts of challenge with batch file" do
  it "solves part 1" do
    File.open("./input.txt") do |file|
      lines = file.readlines(chomp: true)
      expect(
        run_program(lines)[:accumulator]
      ).to eq(1753)
    end
  end
end

def run_program(instructions)
  instructions
    .map{ parse_instruction(_1) }
    .yield_self{ run_instructions(initial_context, _1) }
end

def parse_instruction(instruction)
  instruction, value = instruction.split(" ")
  [instruction.to_sym, value.to_i]
end

def run_instruction(context, instruction)
  case instruction[0]
  when :nop
    context.tap{
      _1[:instruction_pointer] += 1
    }
  when :acc
    context.tap{
      _1[:accumulator] += instruction[1]
      _1[:instruction_pointer] += 1
    }
  when :jmp
    context.tap{
      _1[:instruction_pointer] += instruction[1]
    }
  else
    raise "Unknown instruction #{instruction[0]}\nCurrent context #{context}"
  end
end

def run_instructions(context, instructions)
  current_context = context.dup
  while current_context[:instruction_pointer].between?(0, instructions.length-1) &&
      !current_context[:instruction_pointer_history].include?(current_context[:instruction_pointer])
    current_instruction = instructions[current_context[:instruction_pointer]]
    current_context[:instruction_pointer_history] << current_context[:instruction_pointer]
    current_context = run_instruction(current_context, current_instruction)
  end
  current_context
end

def initial_context
  { accumulator: 0,
    instruction_pointer: 0,
    instruction_pointer_history: []
  }
end

describe "parsing instructions" do
  it "understands nop" do
    instruction = "nop +0"
    expect(parse_instruction(instruction)).to eq [:nop, 0]
  end

  it "understands acc" do
    instruction = "acc +1"
    expect(parse_instruction(instruction)).to eq [:acc, 1]
  end

  it "Understands jmp" do
    instruction = "jmp -3"
    expect(parse_instruction(instruction)).to eq [:jmp, -3]
  end
end

describe "running a program" do
  it "processes a nop with no change" do
    instruction = [:nop, 1]
    new_context = run_instruction(initial_context, instruction)
    expect(new_context[:accumulator]).to eq(0)
  end

  it "processes an acc by adjusting the accumulator" do
    instruction = [:acc, 1]
    new_context = run_instruction(initial_context, instruction)
    expect(new_context[:accumulator]).to eq(1)

    instruction = [:acc, 2]
    new_context = run_instruction(new_context, instruction)
    expect(new_context[:accumulator]).to eq(3)
  end

  it "increments instruction pointer for non-jmp" do
    instruction = [:acc, 1]
    new_context = run_instruction(initial_context, instruction)
    expect(new_context[:instruction_pointer]).to eq(1)
  end

  it "runs multiple instructions" do
    instructions = [
      [:nop, 0],
      [:acc, +1],
      [:acc, +2],
      [:nop, 0]
    ]
    new_context = run_instructions(initial_context, instructions)
    expect(new_context[:accumulator]).to eq(3)
  end

  it "processes a jmp by updating the instruction pointer" do
    instruction = [:jmp, 2]
    new_context = run_instruction(initial_context, instruction)
    expect(new_context[:instruction_pointer]).to eq(2)

    instruction = [:jmp, -1]
    new_context = run_instruction(new_context, instruction)
    expect(new_context[:instruction_pointer]).to eq(1)
    new_context
  end

  it "handles a jmp in the program list" do
    instructions = [
      [:jmp, +2],
      [:acc, +99],
      [:acc, +3]
    ]

    new_context = run_instructions(initial_context, instructions)
    expect(new_context[:accumulator]).to eq(3)
  end

  it "keeps track of executed lines" do
    instructions = [
      [:jmp, +2],
      [:acc, +99],
      [:acc, +3]
    ]

    new_context = run_instructions(initial_context, instructions)
    expect(new_context[:instruction_pointer_history]).to eq([0, 2])
  end

  it "stops on a loop" do
    instructions = [
      [:acc, 1],
      [:jmp, -1],
      [:acc, 99]
    ]
    new_context = run_instructions(initial_context, instructions)
    expect(new_context[:instruction_pointer_history]).to eq([0, 1])
    expect(new_context[:accumulator]).to eq(1)
  end
end
