lines = File.read('day08.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#LLR

#AAA = (BBB, BBB)
#BBB = (AAA, ZZZ)
#ZZZ = (ZZZ, ZZZ)
#END

directions = lines[0].chars
points = lines[2..].each_with_object({}) do |line, hash|
  point, left, right = line.scan(/\w+/)
  hash[point] = [left, right]
end

# part 1

current_point = 'AAA'
index = 0
steps = 0
until current_point == 'ZZZ'
  direction = directions[index]
  current_point = points[current_point][direction == 'L' ? 0 : 1]
  index += 1
  index = 0 if index >= directions.size
  steps += 1
end
p steps

# part 2

#lines = <<END.strip.split("\n")
#LR

#11A = (11B, XXX)
#11B = (XXX, 11Z)
#11Z = (11B, XXX)
#22A = (22B, XXX)
#22B = (22C, 22C)
#22C = (22Z, 22Z)
#22Z = (22B, 22B)
#XXX = (XXX, XXX)
#END

def find_cycle(directions, points, current_point)
  index = 0
  steps = 0
  until steps > 0 && current_point.end_with?('Z')
    direction = directions[index]
    current_point = points[current_point][direction == 'L' ? 0 : 1]
    index += 1
    index = 0 if index >= directions.size
    steps += 1
  end
  steps
end

ghosts = points.keys.select { |k| k.end_with?('A') }
offsets = ghosts.map do |current_point|
  find_cycle(directions, points, current_point)
end
p offsets.reduce(1) { |acc, n| acc.lcm(n) }
