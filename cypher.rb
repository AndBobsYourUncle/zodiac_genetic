require './loading_functions.rb'
require './organism.rb'

NUMBER_OF_GENERATIONS = 1000
STARTING_ORGANISMS = 100
OVERPOPULATION_LEVEL = 2000
DIE_LEVEL = 2.2
BREED_LEVEL = 2
MAX_MUTATIONS = 3
MAX_WORD_COUNT_SCORE = 5
EXCLUDED_WORDS = ['re', 'san', 'ps', 'fran', 'st', 'sf', 'aug', 'oct', 'min']

CYPHER = get_cypher_text
CYPHER_CHARS = get_cypher_characters
TOP_WORDS = get_cypher_word_list
LETTER_COUNTS_TOP_WORDS = get_letter_frequency TOP_WORDS

puts "#{CYPHER_CHARS.length} unique cypher characters"
puts "#{TOP_WORDS.length} most common words from Zodiac's letters for fitness calculation"

# Seed the initial population of organisms
organisms = []
(1..STARTING_ORGANISMS).each do |_num|
  key = {}
  remaining_keys = LETTER_COUNTS_TOP_WORDS.keys
  CYPHER_CHARS.each do |char|
    letter = remaining_keys.sample(1).first
    key[char] = letter
    remaining_keys = remaining_keys - [letter]
    remaining_keys = LETTER_COUNTS_TOP_WORDS.keys if remaining_keys.length == 0
  end

  organism = Organism.new key
  organisms << organism
end

(1..NUMBER_OF_GENERATIONS).each do |generation|
  if organisms.count.zero?
    puts "They all died off at generation #{generation}!"
    break
  end

  fitnesses = organisms.map(&:fitness)
  print "                                                                                                                        \r"
  print "Generation: #{generation}\tMax Fitness: #{fitnesses.max}\tOrganism Count: #{organisms.count}\r"

  median_fitness = median fitnesses

  die_level = ((median_fitness + fitnesses.min) / DIE_LEVEL).to_i
  breed_level = ((median_fitness + fitnesses.max) / BREED_LEVEL).to_i

  # Kill off completely unfit organisms
  organisms = organisms.reject { |org| org.fitness <= die_level }

  # Reduce population back to under the overpopulation limit keeping the most fit
  if organisms.count > OVERPOPULATION_LEVEL
    organisms = organisms.sort_by {|org| -org.fitness}.first(OVERPOPULATION_LEVEL)
  end

  # Separate the most fit into breeding pairs, and breed them
  organisms.select { |org| org.fitness >= breed_level }.shuffle.each_slice(2).to_a.each do |orgs|
    next if orgs.length < 2

    new_org = orgs[0].breed orgs[1]
    organisms << new_org
  end
end

most_fit = organisms.sort_by {|org| -org.fitness}
puts most_fit.first.decoded_cypher
