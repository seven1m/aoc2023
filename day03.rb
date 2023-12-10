lines = File.read('day03.txt').strip.split("\n")

#lines = <<end.strip.split("\n")
#467..114..
#...*......
#..35..633.
#......#...
#617*......
#.....+.58.
#..592.....
#......755.
#...$.*....
#.664.598..
#end

symbols = []
lines.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    next if char =~ /\d|\./

    symbols[y] ||= []
    slot = { char: }
    symbols[y][x] = slot
    slot[:slot] = slot # pointer back to self for convenience
    [
      [x-1, y-1], # upper-left
      [x, y-1], # up
      [x+1, y-1], # upper-right
      [x-1, y], # left
      [x+1, y], # right
      [x-1, y+1], # lower-left
      [x, y+1], # down
      [x+1, y+1], # lower-right
    ].each do |x, y|
      next if x.negative? || y.negative?
      symbols[y] ||= []
      symbols[y][x] = { char: '~', slot: } unless symbols[y][x]
    end
  end
end
#puts 'original map:'
#puts symbols.map { |line| (line + [nil, nil, nil, nil])[0..9].map { |c| c && c[:slot] == c ? c[:char] : '.' }.join }.join("\n")
#puts
#puts 'with blast radius:'
#puts symbols.map { |line| (line + [nil, nil, nil, nil])[0..9].map { |c| c ? c[:char] : '.' }.join }.join("\n")
#exit

numbers = []
lines.each_with_index do |line, y|
  offset = 0
  while (match = line.match(/\d+/, offset))
    x = match.begin(0)
    num = match.to_s.to_i
    length = match.to_s.size
    offset = x + length
    numbers << { num:, x:, y:, length: }
  end
end
#pp numbers

# part 1
sum = 0
numbers.each do |number|
  x = number[:x]
  y = number[:y]
  length = number[:length]
  adjacent = x.upto(x+length-1).any? do |x|
    row = symbols[y]
    row[x] if row
  end
  if adjacent
    sum += number[:num]
  end
end
p sum

# part 2
numbers.each do |number|
  x = number[:x]
  y = number[:y]
  length = number[:length]
  seen = {}
  x.upto(x+length-1).each do |x|
    row = symbols[y]
    if row && (blast_slot = row[x]) && (real_slot = blast_slot[:slot]) && real_slot[:char] == '*'
      next if seen[real_slot]
      real_slot[:parts] ||= []
      real_slot[:parts] << number[:num]
      seen[real_slot] = true
    end
  end
  #puts
  #p number
  #symbols.each do |row|
    #row.each do |slot|
      #if slot && slot[:char] == '*'
        #print slot[:parts] ? slot[:parts].size : 0
      #else
        #print slot ? slot[:char] : '.'
      #end
    #end
    #puts
  #end
end
sum = 0
symbols.each do |row|
  row.each do |part|
    next unless part && part[:char] == '*'
    if part[:parts] && part[:parts].size == 2
      ratio = part[:parts].inject(:*)
      sum += ratio
    end
  end
end
p sum
