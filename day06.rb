lines = File.read('day06.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#Time:      7  15   30
#Distance:  9  40  200
#END

def distances_traveled(duration, record_distance)
  (0..duration).count do |hold_time|
    (duration - hold_time) * hold_time > record_distance
  end
end

# part 1

times = lines[0].scan(/\d+/).map(&:to_i)
distances = lines[1].scan(/\d+/).map(&:to_i)

counts = times.each_with_index.map do |time, i|
  distances_traveled(time, distances[i])
end

p counts.reduce(:*)

# part 2

time = lines[0].scan(/\d+/).join.to_i
distance = lines[1].scan(/\d+/).join.to_i

p distances_traveled(time, distance)
