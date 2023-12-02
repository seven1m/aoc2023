lines = File.read('day2.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
#Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
#Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
#Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
#Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
#END

limits = {
  'red' => 12,
  'green' => 13,
  'blue' => 14,
}

game_hash = {}
lines.each do |line|
  game_name, games = line.split(': ')
  games = games.split('; ').map do |game|
    game.split(', ').each_with_object({}) do |result, hash|
      count, color = result.split(' ')
      hash[color] = count.to_i
    end
  end
  game_num = game_name.split.last.to_i
  game_hash[game_num] = games
end

# part 1
sum = 0
game_hash.each do |game_num, games|
  if games.any? { |game| game.any? { |color, count| count > limits[color] } }
    next
  else
    sum += game_num
  end
end
puts sum

# part 2
sum = 0
game_hash.each do |game_num, games|
  maxes = limits.keys.each_with_object({}) { |color, hash| hash[color] = 0 }
  games.each do |game|
    game.each do |color, count|
      if count > maxes[color]
        maxes[color] = count
      end
    end
  end
  power = maxes.values.reduce(:*)
  sum += power
end
puts sum
