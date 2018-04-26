class Organism
  attr_accessor :cypher_key, :fitness

  def initialize key
    self.cypher_key = key
    self.fitness = calc_fitness
  end

  def decoded_cypher
    string = get_decoded_cypher cypher_key
    TOP_WORDS.each do |word|
      string = string.gsub(word[0], " #{word[0].upcase} ")
    end
    string.gsub(/ +/, ' ')
  end

  def breed organism
    chars_from_me = CYPHER_CHARS.sample((CYPHER_CHARS.count / 2).to_i)
    chars_from_it = CYPHER_CHARS - chars_from_me

    new_key = {}

    chars_from_me.each do |char|
      new_key[char] = cypher_key[char]
    end
    chars_from_it.each do |char|
      new_key[char] = organism.cypher_key[char]
    end

    new_key = mutate_key new_key

    Organism.new new_key
  end

  private

  def mutate_key key
    (1..MAX_MUTATIONS).each do |_num|
      mutation_cypher = CYPHER_CHARS.sample(1).first
      mutation_letter = LETTER_COUNTS_TOP_WORDS.keys.sample(1).first
      key[mutation_cypher] = mutation_letter
    end
    key
  end

  def get_decoded_cypher replacements
    text = CYPHER
    replacements.each do |char, replacement|
      text = text.gsub(char, replacement)
    end
    text
  end

  def calc_fitness
    decoded = get_decoded_cypher cypher_key
    max_word_fitness = TOP_WORDS[TOP_WORDS.length - 1][1] + 1

    TOP_WORDS.inject(0) do |count, word|
      word_fitness = max_word_fitness - word[1]

      word_count = decoded.downcase.scan(/(?=#{word[0]})/).count
      decoded = decoded.gsub(/\b#{word[0]}\b/, '')
      if word_count.zero?
        count
      else
        word_count = MAX_WORD_COUNT_SCORE if word_count > MAX_WORD_COUNT_SCORE
        count += word_count * word_fitness
      end
    end
  end
end
