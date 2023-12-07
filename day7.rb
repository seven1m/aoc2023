lines = File.read('day7.txt').strip.split("\n")

#lines = <<END.strip.split("\n")
#32T3K 765
#T55J5 684
#KK677 28
#KTJJT 220
#QQQJA 483
#END

hands = lines.map do |line|
  hand, bid = line.split
  [hand.chars, bid.to_i]
end

def hand_type(cards)
  uniq_cards = cards.uniq
  if uniq_cards.size == 1
    return :five_of_a_kind
  elsif uniq_cards.size == 2
    c1 = uniq_cards.first
    c2 = uniq_cards.last
    if cards.count(c1) == 4 || cards.count(c2) == 4
      return :four_of_a_kind
    elsif cards.count(c1) == 3 || cards.count(c2) == 3
      return :full_house
    end
  elsif cards.size == uniq_cards.size
    return :high_card
  elsif cards.any? { |c| cards.count(c) == 3 }
    return :three_of_a_kind
  else
    num_pairs = uniq_cards.count { |c| cards.count(c) == 2 }
    case num_pairs
    when 2
      return :two_pair
    when 1
      return :one_pair
    end
  end
  raise "Unknown hand type for #{cards.inspect}"
end

#fail unless hand_type("32T3K".chars) == :one_pair
#fail unless hand_type("KK677".chars) == :two_pair
#fail unless hand_type("KTJJT".chars) == :two_pair
#fail unless hand_type("T55J5".chars) == :three_of_a_kind
#fail unless hand_type("QQQJA".chars) == :three_of_a_kind
#fail unless hand_type("QQQJJ".chars) == :full_house
#fail unless hand_type("QQQQJ".chars) == :four_of_a_kind
#fail unless hand_type("QQQQQ".chars) == :five_of_a_kind
#fail unless hand_type("34632".chars) == :one_pair
#fail unless hand_type("12345".chars) == :high_card

# part 1

card_order = %w[2 3 4 5 6 7 8 9 T J Q K A]
type_order = %i[high_card one_pair two_pair three_of_a_kind full_house four_of_a_kind five_of_a_kind]

values = hands.map do |hand, bid|
  [hand_type(hand), hand, bid]
end
sorted = values.sort_by do |type, hand, bid|
  [type_order.index(type), hand.map { |c| card_order.index(c) }]
end
total_winnings = sorted.each_with_index.map do |(type, hand, bid), i|
  bid * (i + 1)
end.sum
p total_winnings

# part 2

card_order = %w[J 2 3 4 5 6 7 8 9 T Q K A]

def hand_type_with_jokers(hand)
  simple_hand_type = hand_type(hand)
  case simple_hand_type
  when :five_of_a_kind
    return :five_of_a_kind
  when :four_of_a_kind
    if hand.count('J') > 0
      return :five_of_a_kind
    else
      return :four_of_a_kind
    end
  when :full_house
    case hand.count('J')
    when 3, 2
      return :five_of_a_kind
    else
      return :full_house
    end
  when :three_of_a_kind
    if hand.count('J') > 0
      return :four_of_a_kind
    else
      return :three_of_a_kind
    end
  when :two_pair
    case hand.count('J')
    when 1 # 1122J
      return :full_house
    when 2 # 112JJ
      return :four_of_a_kind
    else
      return :two_pair
    end
  when :one_pair
    case hand.count('J')
    when 1, 2 # 1123J, JJ234
      return :three_of_a_kind
    else
      return :one_pair
    end
  when :high_card
    case hand.count('J')
    when 1 # 1234J
      return :one_pair
    else
      return :high_card
    end
  end
  raise "Unhandled hand type #{simple_hand_type} with #{hand.inspect}"
end

#fail unless hand_type_with_jokers("QQQQJ".chars) == :five_of_a_kind
#fail unless hand_type_with_jokers("J55J5".chars) == :five_of_a_kind
#fail unless hand_type_with_jokers("2JJJJ".chars) == :five_of_a_kind
#fail unless hand_type_with_jokers("22JJJ".chars) == :five_of_a_kind
#fail unless hand_type_with_jokers("222JJ".chars) == :five_of_a_kind
#fail unless hand_type_with_jokers("2222J".chars) == :five_of_a_kind

#fail unless hand_type_with_jokers("QQQJA".chars) == :four_of_a_kind
#fail unless hand_type_with_jokers("T55J5".chars) == :four_of_a_kind
#fail unless hand_type_with_jokers("12JJJ".chars) == :four_of_a_kind
#fail unless hand_type_with_jokers("1222J".chars) == :four_of_a_kind
#fail unless hand_type_with_jokers("122JJ".chars) == :four_of_a_kind
#fail unless hand_type_with_jokers("122JJ".chars) == :four_of_a_kind

#fail unless hand_type_with_jokers("455J4".chars) == :full_house

#fail unless hand_type_with_jokers("1123J".chars) == :three_of_a_kind
#fail unless hand_type_with_jokers("123JJ".chars) == :three_of_a_kind

#fail unless hand_type_with_jokers("1234J".chars) == :one_pair

## no wilds:
#fail unless hand_type_with_jokers("12345".chars) == :high_card
#fail unless hand_type_with_jokers("12344".chars) == :one_pair
#fail unless hand_type_with_jokers("12244".chars) == :two_pair
#fail unless hand_type_with_jokers("22244".chars) == :full_house
#fail unless hand_type_with_jokers("22224".chars) == :four_of_a_kind
#fail unless hand_type_with_jokers("22222".chars) == :five_of_a_kind

values = hands.map do |hand, bid|
  [hand_type_with_jokers(hand), hand, bid]
end
sorted = values.sort_by do |type, hand, bid|
  [type_order.index(type), hand.map { |c| card_order.index(c) }]
end
total_winnings = sorted.each_with_index.map do |(type, hand, bid), i|
  bid * (i + 1)
end.sum
p total_winnings
