lines = File.read('day10.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#..F7.
#.FJ|.
#SJ.L7
#|F--J
#LJL.F
#END

#lines = <<END.strip.split("\n")
#.F----7F7F7F7F-7....
#.|F--7||||||||FJ....
#.||.FJ||||||||L7....
#FJL7L7LJLJ||LJ.L-7..
#L--J.L7...LJS7F-7L7.
#....F-J..F7FJ|L7L7L7
#....L7.F7||L7|.L7L7|
#.....|FJLJ|FJ|F7|.LJ
#....FJL-7.||.||||...
#....L---J.LJ.LJLJ...
#END

#lines = <<END.strip.split("\n")
#FF7FSF7F7F7F7F7F---7
#L|LJ||||||||||||F--J
#FL-7LJLJ||||||LJL-77
#F--JF--7||LJLJ7F7FJ-
#L---JF-JLJ.||-FJLJJ7
#|F|F-JF---7F7-L7L|7|
#|FFJF7L7F-JF7|JL---7
#7-L-JL7||F7|L7F-7F7|
#L.L7LFJ|||||FJL7||LJ
#L7JLJL-JLJLJL--JLJ.L
#END

#lines = <<END.strip.split("\n")
#............
#.S--------7.
#.|F----7..|.
#.||....L--J.
#.||....F--7.
#.|L----J..|.
#.|........|.
#.L--------J.
#............
#END

#lines = <<END.strip.split("\n")
#............
#.S---------7.
#.|.F----7..|.
#.L-J....|..|.
#.F-7....|..|.
#.|.L----J..|.
#.|.........|.
#.L---------J.
#............
#END

#lines = <<END.strip.split("\n")
#.............
#.S---7F----7.
#.|...||....|.
#.|.F-JL-7..|.
#.|.|....|..|.
#.|.|....|..|.
#.|.L----J..|.
#.|.........|.
#.L---------J.
#.............
#END

#lines = <<END.strip.split("\n")
#....
#.S7.
#.LJ.
#....
#END

require_relative './dijkstra'

def connect(graph, p1, p2)
  graph[p1] ||= {}
  graph[p1][p2] = 1
  graph[p2] ||= {}
  graph[p2][p1] = 1
end

# part 1

@grid = []
graph = {}
start = nil
1.upto(lines.size) { @grid << [nil] * lines.first.size }
lines.each_with_index do |line, y|
  line.each_char.with_index do |point, x|
    next if point == '.'
    graph[[y, x]] = {}
    @grid[y][x] = point
    start = [y, x] if point == 'S'
  end
end

def up(y, x)
  @grid[y-1][x] if y > 0
end

def left(y, x)
  @grid[y][x-1] if x > 0
end

def down(y, x)
  @grid[y+1][x] if y < @grid.size-1
end

def right(y, x)
  @grid[y][x+1] if x < @grid.first.size-1
end

@grid.each_with_index do |row, y|
  row.each_with_index do |point, x|
    next unless point
    graph[[y, x]] = {}
    connect(graph, [y, x], [y-1, x]) if %w[7 | F].include?(up(y, x)) && %w[| J L S].include?(point)
    connect(graph, [y, x], [y, x-1]) if %w[L - F].include?(left(y, x)) && %w[- J 7 S].include?(point)
    connect(graph, [y, x], [y+1, x]) if %w[L | J].include?(down(y, x)) && %w[| 7 F S].include?(point)
    connect(graph, [y, x], [y, x+1]) if %w[7 - J].include?(right(y, x)) && %w[- L F S].include?(point)
  end
end

distances = dijkstra(graph, start)
p(part1: distances.values.reject { |v| v == Float::INFINITY }.max)

# part 2

@our_pipe = distances.select { |k, v| k if v < Float::INFINITY }

def print_grid(fill, current_point, frame)
  puts frame
  @grid.each_with_index do |row, y|
    row.each_with_index do |char, x|
      if [y, x] == current_point
        print 'X'
      elsif fill[[y, x]]
        print "\033[31;1;4mO\033[0m"
      elsif @our_pipe[[y, x]]
        print "\033[94;1;4m#{char}\033[0m"
      else
        print "\033[32;1;4mI\033[0m"
      end
    end
    puts
  end
end

height = @grid.size
width = @grid.first.size

# fix the S char to be correct...

y, x = start
is_up = %w[7 | F].include?(up(y, x))
is_right = %w[7 - J].include?(right(y, x))
is_down = %w[J | L].include?(down(y, x))
is_left = %w[L - F].include?(left(y, x))

case [is_up, is_right, is_down, is_left]
when [true, true, false, false]
  @grid[y][x] = 'L'
when [false, true, true, false]
  @grid[y][x] = 'F'
when [false, false, true, true]
  @grid[y][x] = '7'
when [true, false, false, true]
  @grid[y][x] = 'J'
when [true, false, true, false]
  @grid[y][x] = '|'
when [false, true, false, true]
  @grid[y][x] = '-'
else
  raise 'expected exactly two directions to link'
end

graph = {}
fill = {}

def down_stem(char)
  %w[7 | F].include?(char)
end

def up_stem(char)
  %w[J | L].include?(char)
end

def left_stem(char)
  %w[J - 7].include?(char)
end

def right_stem(char)
  %w[L - F].include?(char)
end

new_grid = []
@grid.each_with_index do |row, y|
  new_grid[y * 2] ||= ([nil] * (row.size * 2 + 1)).dup
  row.each_with_index do |char, x|
    new_grid[y * 2 + 1] ||= []
    new_grid[y * 2 + 1][x * 2 + 1] = char
  end
  new_grid[y * 2 + 1] << nil
@grid = new_grid
new_grid << ([nil] * new_grid.first.size)
end

new_pipe = {}
@our_pipe.keys.each do |y, x|
  new_pipe[[y * 2 + 1, x * 2 + 1]] = true
end
@our_pipe = new_pipe

def print_grid2(fill)
  count_i = 0
  @grid.each_with_index do |row, y|
    row.each_with_index do |char, x|
      if fill[[y, x]]
        print "\033[31;1mO\033[0m"
      elsif @our_pipe[[y, x]]
        print "\033[94;1m#{char}\033[0m"
      elsif y.odd? && x.odd?
        print "\033[32;1mI\033[0m"
        count_i += 1
      else
        print '.'
      end
    end
    puts
  end
  p(i: count_i)
end

#print_grid2({})

0.step(by: 2).take(height+1).each do |y|
  0.step(by: 2).take(width+1).each do |x|
    ul = @our_pipe[[y-1, x-1]] && @grid[y-1][x-1]
    ur = @our_pipe[[y-1, x+1]] && @grid[y-1][x+1]
    ll = @our_pipe[[y+1, x-1]] && @grid[y+1][x-1]
    lr = @our_pipe[[y+1, x+1]] && @grid[y+1][x+1]

    intersects_line = lambda do |y, x|
      left = @our_pipe[[y, x-1]] && @grid[y][x-1]
      right = @our_pipe[[y, x+1]] && @grid[y][x+1]
      up = @our_pipe[[y-1, x]] && @grid[y-1][x]
      down = @our_pipe[[y+1, x]] && @grid[y+1][x]

      right_stem(left) || down_stem(up) || left_stem(right) || up_stem(down)
    end

    next if intersects_line.(y, x)

    connect(graph, [y, x], [y-1, x-1]) unless ul
    connect(graph, [y, x], [y+1, x-1]) unless ll
    connect(graph, [y, x], [y-1, x+1]) unless ur
    connect(graph, [y, x], [y+1, x+1]) unless lr

    # can go up
    if (down_stem(ul) || left_stem(ul)) && (down_stem(ur) || right_stem(ur))
      connect(graph, [y, x], [y-1, x]) unless intersects_line.(y-1, x)
    end

    # can go down
    if (up_stem(ll) || left_stem(ll)) && (up_stem(lr) || right_stem(lr))
      connect(graph, [y, x], [y+1, x]) unless intersects_line.(y+1, x)
    end

    # can go left
    if (right_stem(ul) || up_stem(ul)) && (right_stem(ll) || down_stem(ll))
      connect(graph, [y, x], [y, x-1]) unless intersects_line.(y, x-1)
    end

    # can go right
    if (left_stem(ur) || up_stem(ur)) && (left_stem(lr) || down_stem(lr))
      connect(graph, [y, x], [y, x+1]) unless intersects_line.(y, x+1)
    end

    #if (connections = graph[[3, 3]]) && connections[[2, 3]]
      #p([y, x])
      #pp graph[[2, 3]]
      #pp graph[[3, 3]]
      #raise 'but why'
    #end

    #puts; puts; puts
    #distances = dijkstra(graph, [1, 1])
    #fill = {}
    #distances.each do |(y, x), distance|
      #fill[[y, x]] = true if distance < Float::INFINITY && y.odd? && x.odd?
    #end
    #print_grid2(fill)
  end
end

distances = dijkstra(graph, [0, 0])
fill = {}
distances.each do |(y, x), distance|
  fill[[y, x]] = true if distance < Float::INFINITY && y.odd? && x.odd?
end
print_grid2(fill)
