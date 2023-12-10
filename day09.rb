lines = File.read('day09.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#0 3 6 9 12 15
#1 3 6 10 15 21
#10 13 16 21 30 45
#END

def build_diffs(nums)
  nums.each_cons(2).map { |a, b| b - a }
end

# part 1

results = lines.map do |line|
  nums = line.split.map(&:to_i)
  diffs = [nums]
  begin
    diffs << build_diffs(diffs.last)
  end until diffs.last.all?(&:zero?)

  diffs.last << 0
  (0..(diffs.size - 2)).reverse_each do |index|
    diff = diffs[index]
    below_diff = diffs[index + 1]
    diff << diff.last + below_diff.last
  end
  diffs.first.last
end
p results.sum

# part 2

results = lines.map do |line|
  nums = line.split.map(&:to_i)
  diffs = [nums]
  begin
    diffs << build_diffs(diffs.last)
  end until diffs.last.all?(&:zero?)

  diffs.last << 0
  (0..(diffs.size - 2)).reverse_each do |index|
    diff = diffs[index]
    below_diff = diffs[index + 1]
    diff.unshift diff.first - below_diff.first
  end
  diffs.first.first
end
p results.sum
