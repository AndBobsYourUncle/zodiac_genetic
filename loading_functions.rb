def get_cypher_text
  cypher = ''
  File.open("./340cypher.txt", "r") do |f|
    f.each_line do |line|
      cypher += line.gsub("\n", '').gsub(' ', '')
    end
  end
  cypher
end

def get_cypher_characters
  cypher_chars = []
  File.open("./340cypher.txt", "r") do |f|
    f.each_line do |line|
      chars = line.split(' ')
      chars.each { |char| cypher_chars << char unless cypher_chars.include? char }
    end
  end
  cypher_chars
end

def get_cypher_word_list
  word_counts = {}
  (1..27).each do |letter_num|
    letter = ''
    File.open("./letters/letter#{letter_num}.txt", "r") do |f|
      f.each_line do |line|
        line_clean = line.gsub(/[^\w\s]/, '')
        words = line_clean.split(' ').select { |word| (word.length > 1) && word.gsub(/[0-9]/, '').length == word.length }.map(&:downcase)
        words.each do |word|
          word_counts[word] ||= 0
          word_counts[word] += 1
        end
      end
    end
  end

  # remove word scanned from his letters that aren't real words
  EXCLUDED_WORDS.each { |word| word_counts.delete(word) }

  word_counts.sort_by {|_key, value| -value}.first(297).reverse
end

def get_letter_frequency word_list
  letter_counts_word_list = {}
  word_list.each do |word|
    word[0].split('').each do |char|
      letter_counts_word_list[char] ||= 0
      letter_counts_word_list[char] += 1
    end
  end
  letter_counts_word_list
end

def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end
