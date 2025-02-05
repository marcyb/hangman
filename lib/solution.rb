# frozen_string_literal: true

require 'colorize'
require 'delegate'
require 'base64'
require_relative 'dictionary'

# Solution class
class Solution < SimpleDelegator
  ALPHABET = ('a'..'z').to_a

  def initialize(word = Dictionary.pick, guesses = [])
    @word = word
    self.guesses = guesses
    super(Array.new(@word.length, '_'))
    refresh
  end

  def guess
    @guesses << letter_input
    found = @word.include?(@guesses[-1])
    if found
      puts "\nWell done, the word contains the letter '#{@guesses[-1]}'!\n"
    else
      puts "\nSorry, the word does not contain the letter '#{@guesses[-1]}'\n"
    end
    refresh
    found
  end

  def solved?
    join == @word
  end

  def success
    puts "\nCONGRATULATIONS!! The word was: #{@word.center(@word.length + 2).black.on_green.bold}"
    puts
  end

  def failure
    puts "The word was: #{@word.white.on_red.bold}"
    puts
  end

  def to_hash
    {
      '@word': Base64.encode64(@word),
      '@guesses': @guesses
    }
  end

  class << self
    def from_hash(hash)
      new(Base64.decode64(hash['@word']), hash['@guesses'])
    end
  end

  private

  def guesses=(arr)
    @guesses = arr
    puts "\nPrevious guesses: #{@guesses}" unless @guesses.empty?
  end

  def refresh
    update
    display
  end

  def letter_input
    puts "\nGuess a letter:"
    loop do
      input = gets.chomp.downcase
      if ALPHABET.include?(input)
        return input unless @guesses.include?(input)

        puts "Letter '#{input}' already guessed"
      else
        puts 'Enter a single letter'
      end
    end
  end

  def update
    @word.chars.each_with_index do |char, i|
      self[i] = char if @guesses.include?(char)
    end
  end

  def display
    puts "\n#{join(' ').center((length * 2) + 3).magenta.on_white.bold}"
  end
end
