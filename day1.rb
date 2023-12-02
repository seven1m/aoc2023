lines = File.read('day1.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#two1nine
#eightwothree
#abcone2threexyz
#xtwone3four
#4nineeightseven2
#zoneight234
#7pqrstsixteen
#END
#require 'pp'
#pp lines

# part 1
p lines.map { |l| digits = l.scan(/\d/); (digits.first + digits.last).to_i }.sum

DIGITS = %w[1 2 3 4 5 6 7 8 9]
WORDS = %w[_ one two three four five six seven eight nine]

def to_digit(word)
  if word =~ /^\d$/
    word.to_i
  else
    WORDS.index(word) or raise 'wat'
  end
end

# This was my personal solution to part 2, but there is a simpler solution below
# that uses lookaheads.
results = lines.map do |line|
  first_word = (DIGITS + WORDS).sort_by { |w| line.index(w) || 1000 }.first
  first_digit = to_digit(first_word)

  last_word = (DIGITS + WORDS).sort_by { |w| line.rindex(w) || -1000 }.last
  last_digit = to_digit(last_word)

  combined = "#{first_digit}#{last_digit}"
  raise 'wat' if combined.size != 2

  combined.to_i
end
puts results.sum

# This is the simpler solution that Kyle and Tanner helped me with!
results = lines.map do |line|
  words = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).map(&:first)
  "#{to_digit(words.first)}#{to_digit(words.last)}".to_i
end
puts results.sum
