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
#............
#.S---7F----7.
#.|...||....|.
#.|.F-JL-7..|.
#.|.|....|..|.
#.|.|....|..|.
#.|.L----J..|.
#.|.........|.
#.L---------J.
#............
#END

# Dijkstra's algorithm
# https://medium.com/cracking-the-coding-interview-in-ruby-python-and/dijkstras-shortest-path-algorithm-in-ruby-951417829173

def dijkstra(graph, start)
  # Create a hash to store the shortest distance from the start node to every other node
  distances = {}
  # A hash to keep track of visited nodes
  visited = {}
  # Extract all the node keys from the graph
  nodes = graph.keys

  # Initially, set every node's shortest distance as infinity
  nodes.each do |node|
    distances[node] = Float::INFINITY
  end
  # The distance from the start node to itself is always 0
  distances[start] = 0

  # Loop through until all nodes are visited
  until nodes.empty?
    print "#{nodes.size} \r"
    min_node = nil

    # Iterate through each node
    nodes.each do |node|
      # Select the node with the smallest known distance
      if min_node.nil? || distances[node] < distances[min_node]
        # Ensure the node hasn't been visited yet
        min_node = node unless visited[node]
      end
    end

    # If the shortest distance to the closest node is infinity, other nodes are unreachable. Break the loop.
    break if distances[min_node] == Float::INFINITY

    # For each neighboring node of the current node
    graph[min_node].each do |neighbor, value|
      # Calculate tentative distance to the neighboring node
      alt = distances[min_node] + value
      # If this newly computed distance is shorter than the previously known one, update the shortest distance for the neighbor
      distances[neighbor] = alt if alt < distances[neighbor]
    end

    # Mark the node as visited
    visited[min_node] = true
    # Remove the node from the list of unvisited nodes
    nodes.delete(min_node)
  end

  puts

  # Return the shortest distances from the starting node to all other nodes
  distances
end

def connect(graph, p1, p2)
  graph[p1] ||= {}
  graph[p1][p2] = 1
  graph[p2] ||= {}
  graph[p2][p1] = 1
end

# part 1

grid = []
graph = {}
start = nil
1.upto(lines.size) { grid << [nil] * lines.first.size }
lines.each_with_index do |line, y|
  line.each_char.with_index do |point, x|
    next if point == '.'
    graph[[y, x]] = {}
    grid[y][x] = point
    start = [y, x] if point == 'S'
  end
end

grid.each_with_index do |row, y|
  row.each_with_index do |point, x|
    next unless point
    graph[[y, x]] = {}
    # up
    up = grid[y-1][x] if y > 0
    connect(graph, [y, x], [y-1, x]) if %w[7 | F].include?(up) && %w[| J L S].include?(point)
    # left
    left = grid[y][x-1] if x > 0
    connect(graph, [y, x], [y, x-1]) if %w[L - F].include?(left) && %w[- J 7 S].include?(point)
    # down
    down = grid[y+1][x] if y < grid.size-1
    connect(graph, [y, x], [y+1, x]) if %w[L | J].include?(down) && %w[| 7 F S].include?(point)
    # right
    right = grid[y][x+1] if x < row.size-1
    connect(graph, [y, x], [y, x+1]) if %w[7 - J].include?(right) && %w[- L F S].include?(point)
  end
end

distances = dijkstra(graph, start)
p(part1: distances.values.reject { |v| v == Float::INFINITY }.max)

# part 2

@our_pipe = distances.select { |k, v| k if v < Float::INFINITY }

def print_grid(grid, fill, current_point, frame)
  puts frame
  grid.each_with_index do |row, y|
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

height = grid.size
width = grid.first.size

# fix S
y, x = start
left_of_start = grid[y][x-1] if x > 0
right_of_start = grid[y][x+1] if x < grid.first.size - 1
above_start = grid[y - 1][x] if y > 0
below_start = grid[y + 1][x] if y < grid.size - 1

p([above_start, right_of_start, below_start, left_of_start])

# fix the S char to be correct...

up = %w[7 | F].include?(above_start)
right = %w[7 - J].include?(right_of_start)
down = %w[J | L].include?(below_start)
left = %w[L - F].include?(left_of_start)

raise 'wat' if [up, right, down, left].count(true) != 2

case [up, right, down, left]
when [true, true, false, false]
  grid[y][x] = 'L'
when [false, true, true, false]
  grid[y][x] = 'F'
when [false, false, true, true]
  grid[y][x] = '7'
when [true, false, false, true]
  grid[y][x] = 'J'
when [true, false, true, false]
  grid[y][x] = '|'
when [false, true, false, true]
  grid[y][x] = '-'
else
  raise 'wat'
end

# fill inside pipe

frame = 0
fill = {}
seen = {}
queue = [{ point: [0, 0] }]
while queue.any?
  item = queue.shift
  y, x = item.fetch(:point)
  next if seen[[y, x]]

  fill[[y, x]] = true unless item[:side]

  seen[[y, x]] = true

  # JL-    -JL
  # .X.    .X.
  if (up = y > 0 ? [y-1, x] : nil)
    char = @our_pipe[up] && grid[up[0]][up[1]]
    side = item[:side]
    if !@our_pipe[up] && (side.nil? || side == :up)
      queue << { point: up }
    elsif char == 'L' && side.nil?
      queue << { point: up, side: :left }
    elsif char == 'J' && side.nil?
      queue << { point: up, side: :right }
    elsif char == '7' && side != :down
      queue << { point: up, side: side == :left ? :down : :up }
    elsif char == 'F' && side != :down
      queue << { point: up, side: side == :left ? :up : :down }
    elsif char == '|' && %i[left right].include?(side)
      queue << { point: up, side: }
    end
  end

  # J.    |.
  # 7X    JX
  # |.    7.
  if (left = x > 0 ? [y, x-1] : nil)
    char = @our_pipe[left] && grid[left[0]][left[1]]
    side = item[:side]
    if !@our_pipe[left] && (side.nil? || side == :left)
      queue << { point: left }
    elsif char == '7' && side.nil?
      queue << { point: left, side: :up }
    elsif char == 'J' && side.nil?
      queue << { point: left, side: :down }
    elsif char == 'L' && side != :right
      queue << { point: left, side: side == :up ? :right : :left }
    elsif char == 'F' && side != :right
      queue << { point: left, side: side == :up ? :left : :right }
    elsif char == '-' && %i[up down].include?(side)
      queue << { point: left, side: }
    end
  end

  # .X.    .X.
  # 7F-    -7F
  if (down = y < height-1 ? [y+1, x] : nil)
    char = @our_pipe[down] && grid[down[0]][down[1]]
    side = item[:side]
    if !@our_pipe[down] && (side.nil? || side == :down)
      queue << { point: down }
    elsif char == 'F' && side.nil?
      queue << { point: down, side: :left }
    elsif char == '7' && side.nil?
      queue << { point: down, side: :right }
    elsif char == 'J' && side != :up
      queue << { point: down, side: side == :left ? :up : :down }
    elsif char == 'L' && side != :up
      queue << { point: down, side: side == :left ? :down : :up }
    elsif char == '|' && %i[left right].include?(side)
      queue << { point: down, side: }
    end
  end

  # .L    .|
  # XF    XL
  # .|    .F
  if (right = x < width-1 ? [y, x+1] : nil)
    char = @our_pipe[right] && grid[right[0]][right[1]]
    side = item[:side]
    if !@our_pipe[right] && (side.nil? || side == :right)
      queue << { point: right }
    elsif char == 'F' && side.nil?
      queue << { point: right, side: :up } # this assumption is maybe wrong?
    elsif char == 'L' && side.nil?
      queue << { point: right, side: :down }
    elsif char == '7' && side != :left
      queue << { point: right, side: side == :up ? :right : :left }
    elsif char == 'J' && side != :left
      queue << { point: right, side: side == :up ? :left : :right }
    elsif char == '-' && %i[up down].include?(side)
      queue << { point: right, side: }
    end
  end

  #print_grid(grid, fill, item[:point], frame)

  #if frame == 80
    #binding.irb
  #end
  #frame += 1
  #puts

  #if queue.detect { |i| i == {:point=>[4, 7], :side=>:up} }
    #p item
    #raise 'wat'
  #end

  #if queue.last(4).any? { |i| i[:point] == [4, 7] }
    #p item
    #p queue.last(4)
    #raise '4, 7 added here'
  #end
end

# problem: going from outside pipe to inside works
# once I'm inside, there is a bug that allows me to cross the pipe

print_grid(grid, fill, [0, 0], 0)
puts
p (width * height) - @our_pipe.size - fill.size
# attempt 1: 165 (too low)
# attempt 2: 94 :-(
# attempt 3: 98 :-(
# attempt 4: 484 (too high)
# attempt 5: 478 :-(
