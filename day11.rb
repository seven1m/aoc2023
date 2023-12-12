lines = File.read('day11.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#...#......
#.......#..
##.........
#..........
#......#...
#.#........
#.........#
#..........
#.......#..
##...#.....
#END

expansion_amount = (1000000 - 1) # one less than specification because we add instead of multiply

# part 1 and 2 combined...

grid = lines.map { |line| line.chars }

# number galaxies
galaxies = {}
grid = {}
@max_y = 0
@max_x = 0
cols_with_galaxies = {}
rows_with_galaxies = {}
index = 0
lines.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    if char == '#'
      index += 1
      galaxies[index] = [y, x]
      grid[[y, x]] = index
      @max_y = y if y > @max_y
      @max_x = x if x > @max_x
      rows_with_galaxies[y] ||= 0
      rows_with_galaxies[y] += 1
      cols_with_galaxies[x] ||= 0
      cols_with_galaxies[x] += 1
    end
  end
end

def print_grid(grid)
  (0..@max_y).each do |y|
    (0..@max_x).each do |x|
      if (galaxy = grid[[y, x]])
        print galaxy
      else
        print '.'
      end
    end
    puts
  end
end

# expand vertically
y = @max_y
while y > 0
  unless rows_with_galaxies[y].to_i > 0
    # everything below this row needs to move
    galaxies.each do |galaxy, (y2, x2)|
      next unless y2 > y
      new_y = y2 + expansion_amount
      new_coord = [new_y, x2]
      puts "#{galaxy} moving from #{y2}, #{x2} to #{new_coord.inspect}"
      grid[new_coord] = galaxy
      galaxies[galaxy] = new_coord
      @max_y = new_y if new_y > @max_y
      rows_with_galaxies.keys.sort.reverse_each do |row|
        break if row <= y
        rows_with_galaxies[y] -= 1 if rows_with_galaxies[y]
        raise 'wat' if cols_with_galaxies[y].to_i < 0
        rows_with_galaxies[new_y] ||= 0
        rows_with_galaxies[new_y] += 1
      end
    end
  end
  y -= 1
end

# expand horizontally
x = @max_x
while x > 0
  unless cols_with_galaxies[x].to_i > 0
    # everything right of this row needs to move
    galaxies.each do |galaxy, (y2, x2)|
      next unless x2 > x
      y2, x2 = galaxies[galaxy]
      new_x = x2 + expansion_amount
      new_coord = [y2, new_x]
      puts "#{galaxy} moving from #{y2}, #{x2} to #{new_coord.inspect}"
      grid[new_coord] = galaxy
      galaxies[galaxy] = new_coord
      @max_x = new_x if new_x > @max_x
      cols_with_galaxies.keys.sort.reverse_each do |col|
        break if col <= x
        cols_with_galaxies[x] -= 1 if cols_with_galaxies[x]
        raise 'wat' if cols_with_galaxies[x].to_i < 0
        cols_with_galaxies[new_x] ||= 0
        cols_with_galaxies[new_x] += 1
      end
    end
  end
  x -= 1
end

#print_grid(grid)

# calculate distance between each galaxy pair
sum = 0
pairs = galaxies.keys.combination(2).to_a
pairs.each_with_index do |(g1, g2), index|
  print "calculation: #{index} of #{pairs.size} \r"
  y1, x1 = galaxies[g1]
  y2, x2 = galaxies[g2]
  distance = (y2 - y1).abs + (x2 - x1).abs
  sum += distance
  #puts "#{g1} -> #{g2}: #{distance.inspect}"
end
puts
p sum

# => part 1: 9627977 (change expansion_amount to 1 to get this result)

# => part 2: 644248339497
