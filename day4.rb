lines = File.read('day4.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
#Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
#Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
#Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
#Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
#Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
#END

# part 1
total_points = 0
lines.each do |line|
  winning_numbers, my_numbers = line.split(':').last.split('|').map(&:strip).map { |part| part.split.map(&:to_i) }
  card_points = 0
  matching_numbers = winning_numbers.select { |num| my_numbers.include?(num) }
  matching_numbers.each_with_index do |num|
    if card_points.zero?
      card_points = 1
    else
      card_points *= 2
    end
  end
  total_points += card_points
end
puts total_points

# part 2
total_cards = 0
cards = lines.each_with_object({}) do |line, hash|
  card_num, details = line.split(':')
  card_num = card_num.match(/\d+/)[0].to_i
  winning_numbers, my_numbers = details.split('|').map(&:strip).map { |part| part.split.map(&:to_i) }
  hash[card_num] = {
    winning_number_count: (winning_numbers & my_numbers).size,
    card_count: 1
  }
end
#require 'pp'
#pp cards
total_cards = 0
biggest_card = cards.keys.max
cards.each do |card_num, card|
  print "#{card_num} of #{biggest_card}\r"
  total_cards += card[:card_count]
  next_cards = (card_num + 1).upto(card_num + card[:winning_number_count]).to_a
  next_cards.each do |i|
    cards[i][:card_count] += card[:card_count]
  end
end
print "                   \r"
puts total_cards
