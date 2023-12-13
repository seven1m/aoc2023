# encoding: us-ascii

#line = '???.### 1,1,3'
#line = '????.#...#... 4,1,1'
#line = '????..???#.?? 3,4'
#line = '?###???????? 3,2,1'
#line = '?????????.??# 1,1,4,2'
#line = '...??.?????????.?.. 1,5'
#line = '????.######..#####. 1,6,5'
#line = '?###???????? 3,2,1'
#line = '????.#...#... 4,1,1'
#line = '.??..??...?##. 1,1,3'

#p input
#p springs

#p springs.sum + springs.length - 1
#p input.length
#p 99 - 74

@count_cache = {}
@none_cache = {}
@found_cache = {}
@cache_window_sizes = [8, 6, 4] # all must be even

def stability_magic_number(window_size)
  20 ** window_size # determined by trial and error :-)
end

def next_available_slots(input, springs, left_indices = [], right_indices = [], range = 0...input.size)
  #p(side: :left, left_indices:, right_indices:)

  if (hits = cache_hit(springs, left_indices, right_indices))
    #hits.each do |indices|
      #yield indices
    #end
    return hits.size
  end

  if springs.empty? || input.nil?
    cache_window(left_indices, right_indices)
    indices = left_indices + right_indices
    #yield indices
    return 1
  end

  spring = springs.first
  remaining_springs = springs[1..]
  last_one = remaining_springs.empty?
  space = input.length - (remaining_springs.sum + remaining_springs.length - (last_one ? 1 : 0))
  search_space = input[..space]
  #p search_space

  count_key = [range, remaining_springs]
  if (count = @count_cache[count_key])
    #count.times do
      #yield nil # we don't care about this
    #end
    return count
  end

  found = 0
  (0..search_space.size-spring).each do |index|
    # don't leave any springs behind
    break if search_space[...index].include?(?#) 
    # can't be any springs after the last one
    next if last_one && search_space[index+spring..].include?(?#)

    chars = search_space[index,spring]
    unless last_one
      gap = input[index+spring]
      next unless gap == ?. || gap == ??
    end
    #p(chars:, spring:)
    #if chars.match?(/^[\#\?]{#{spring}}$/)
    if chars.chars.count { |c| c == ?# || c == ?? } == spring
      #if spring == 6
        #p(index:, spring:, search_space:, input_trunc: input[index+spring..])
      #end
      remaining_input = input[index+spring+1..]

      key = [left_indices.size, right_indices.size, index, range]
      if @none_cache[key]
        # noop
      else
        found_here = next_available_right_slots(
          remaining_input,
          remaining_springs,
          left_indices + [range.begin + index],
          right_indices,
          (range.begin + index + spring + 1)...(range.end)
        )
        if found_here == 0
          @none_cache[key] = true
        end
        found += found_here
      end
    end
  end

  @count_cache[count_key] = found

  #if input.chars.all? { |c| c == ?? } && input.size > 2
    #p(input:, found:, spring:, remaining_springs:)
  #end
  found
end

def next_available_right_slots(input, springs, left_indices, right_indices, range)
  #p(side: :right, left_indices:, right_indices:)

  if (hits = cache_hit(springs, left_indices, right_indices))
    #hits.each do |indices|
      #yield indices
    #end
    return hits.size
  end

  if springs.empty? || input.nil?
    cache_window(left_indices, right_indices)
    indices = left_indices + right_indices
    #yield indices
    return 1
  end

  spring = springs.last
  remaining_springs = springs[...-1]
  last_one = remaining_springs.empty?
  if last_one
    space = input.size
    search_space = input
  else
    space = input.length - (remaining_springs.sum + remaining_springs.length)
    if space <= 0
      search_space = ''
    else
      search_space = input[-space..]
    end
  end

  count_key = [range, remaining_springs]
  if (count = @count_cache[count_key])
    #count.times do
      #yield nil # we don't care about this
    #end
    return count
  end

  found = 0
  (0..search_space.size-spring).reverse_each do |index|
    # don't leave any springs after us
    break if search_space[index+spring..].include?(?#) 
    # can't be any springs before the last one
    next if last_one && search_space[...index].include?(?#)

    chars = search_space[index,spring]
    unless last_one
      gap_index = input.size-space+index-1
      gap = input[input.size-space+index-1]
      next unless gap == ?. || gap == ??
    end
    if chars.chars.count { |c| c == ?# || c == ?? } == spring
      #p(index:, spring:, search_space:)
      #if spring == 6
        #p(index:, spring:, search_space:, input_trunc: input[index+spring..])
      #end
      remaining_ending_index = input.size - space + index - 1
      remaining_input = input[...remaining_ending_index]
      new_index = range.end - space + index
      new_range = (range.begin)...(range.end - space + index - 1 - (last_one ? 0 : 1)) # include the gap!
      #p(remaining_ending_index:, remaining_input:)
      #p(range:, space:, index:, input:, new_index:, new_range:)
      #if new_index == 10
        #p(remaining_ending_index:, remaining_input:)
        #p(range:, space:, search_space:, index:, input:, new_index:, new_range:)
        #raise 'nope'
      #end
      key = [left_indices.size, right_indices.size, index, range]
      if @none_cache[key]
        # noop
      else
        found_here = next_available_slots(
          remaining_input,
          remaining_springs,
          left_indices,
          [new_index] + right_indices,
          new_range
        )
        if found_here == 0
          @none_cache[key] = true
        end
        found += found_here
      end
    end
  end

  @count_cache[count_key] = found

  found
end

def cache_window(left_indices, right_indices)
  @cache_window_sizes.each do |cache_window_size|
    cache_info = @found_cache[cache_window_size] ||= {}
    if left_indices.size > cache_window_size/2 && right_indices.size > cache_window_size/2
      window = left_indices.last(cache_window_size/2) + right_indices.first(cache_window_size/2)
      cache_info[:window] ||= {}
      cache_info[:stability] ||= 0
      if cache_info[:window][window]
        cache_info[:stability] += 1
      else
        cache_info[:stability] = 0
        cache_info[:window][window] = true
      end
      if cache_info[:stability] > stability_magic_number(cache_window_size) && !cache_info[:stable]
        #puts 'stable'
        cache_info[:stable] = true
      end
    end
  end
end

def cache_hit(springs, left_indices, right_indices)
  @cache_window_sizes.each do |cache_window_size|
    cache_info = @found_cache[cache_window_size] ||= {}
    if springs.size == cache_window_size && cache_info[:stable]
      cached = cache_info[:window].keys
      return cached.map do |middle_indices|
        left_indices + middle_indices + right_indices
      end
    end
  end
  nil
end

lines = File.read(ARGV.first || 'day12.txt').strip.split("\n")

#lines = <<END.strip.split(/\n/)
#???.### 1,1,3
#.??..??...?##. 1,1,3
#?#?#?#?#?#?#?#? 1,3,1,6
#????.#...#... 4,1,1
#????.######..#####. 1,6,5
#?###???????? 3,2,1
#END

#lines = <<END.strip.split(/\n/)
##?????.?????#??????? 4,1,7,1
#END
# => 996581125

results = lines.map do |line|
  input, springs = line.split
  next 0 if input[0] == '-'
  springs = springs.split(',').map(&:to_i)

  # for part 2:
  input = (1..5).map { input }.join('?')
  springs = springs * 5

  @count_cache = {}
  @none_cache = {}
  @found_cache = {}

  #puts
  #p input
  #p springs
  #count = 0
  #next_available_slots(input, springs) do |indices|
    ##break if count > 100
    #count += 1
  #end
  p count = next_available_slots(input, springs)
  count
end
p results.sum
exit
