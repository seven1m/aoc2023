lines = File.read('day05.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#seeds: 79 14 55 13

#seed-to-soil map:
#50 98 2
#52 50 48

#soil-to-fertilizer map:
#0 15 37
#37 52 2
#39 0 15

#fertilizer-to-water map:
#49 53 8
#0 11 42
#42 0 7
#57 7 4

#water-to-light map:
#88 18 7
#18 25 70

#light-to-temperature map:
#45 77 23
#81 45 19
#68 64 13

#temperature-to-humidity map:
#0 69 1
#1 0 69

#humidity-to-location map:
#60 56 37
#56 93 4
#END

seeds = lines.first.split(': ').last.split.map(&:to_i)
@maps = lines[1..].join("\n").split("\n\n").each_with_object({}) do |chunk, hash|
  chunk.match(/(\w+)-to-(\w+) map:\n(.*)/m)
  from = $1
  ranges = $3.split("\n").map { |line| line.split.map(&:to_i) }
  translate = ranges.map do |dest_range_start, source_range_start, range_length|
    {
      from: source_range_start...(source_range_start + range_length),
      to: dest_range_start...(dest_range_start + range_length)
    }
  end
  hash[from] = {
    to: $2,
    ranges:,
    translate:,
  }
end
#require 'pp'
#pp @maps

def map_value_in_range(value, map)
  map[:translate].each do |range|
    if range[:from].include?(value)
      return range[:to].begin + (value - range[:from].begin)
    end
  end
  value # fallback
end

def map_value_in_reverse(value, map)
  map[:translate].each do |range|
    if range[:to].include?(value)
      return range[:from].begin + (value - range[:to].begin)
    end
  end
  value # fallback
end

#p map_value_in_range(79, @maps['seed']) # => 81
#p map_value_in_range(14, @maps['seed']) # => 14
#p map_value_in_range(55, @maps['seed']) # => 57
#p map_value_in_range(13, @maps['seed']) # => 13
#exit

def seed_to_location(seed)
  soil = map_value_in_range(seed, @maps['seed'])
  fertilizer = map_value_in_range(soil, @maps['soil'])
  water = map_value_in_range(fertilizer, @maps['fertilizer'])
  light = map_value_in_range(water, @maps['water'])
  temperature = map_value_in_range(light, @maps['light'])
  humidity = map_value_in_range(temperature, @maps['temperature'])
  location = map_value_in_range(humidity, @maps['humidity'])
  location
end

# part 1
locations = seeds.map do |seed|
  seed_to_location(seed)
end
p locations.min


# part 2

@seed_ranges = seeds.each_slice(2).map { |start, length| start...(start + length) }

def find_matching_seed(location)
  humidity = map_value_in_reverse(location, @maps['humidity'])
  temperature = map_value_in_reverse(humidity, @maps['temperature'])
  light = map_value_in_reverse(temperature, @maps['light'])
  water = map_value_in_reverse(light, @maps['water'])
  fertilizer = map_value_in_reverse(water, @maps['fertilizer'])
  soil = map_value_in_reverse(fertilizer, @maps['soil'])
  seed = map_value_in_reverse(soil, @maps['seed'])
  @seed_ranges.any? { |range| range.include?(seed) }
end

good_start = 1
until find_matching_seed(good_start)
  good_start += 100_000
end
good_start -= 100_000
puts "starting at #{good_start}"

min = good_start.upto(@maps['humidity'][:translate].sort_by { |r| r[:to].begin }.last[:to].end).detect do |location|
  print "trying location #{location} \r"
  find_matching_seed(location)
end
puts
p min
