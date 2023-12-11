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
