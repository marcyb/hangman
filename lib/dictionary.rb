# frozen_string_literal: true

# Dictionary class
class Dictionary
  MIN_WORD_LENGTH = 5
  MAX_WORD_LENGTH = 12

  class << self
    def read(file = 'google-10000-english-no-swears.txt')
      File.readlines(file).map(&:chomp).select do |word|
        (MIN_WORD_LENGTH..MAX_WORD_LENGTH).include?(word.length)
      end
    end

    def pick
      read.sample
    end
  end
end
