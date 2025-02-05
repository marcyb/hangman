# frozen_string_literal: true

require 'json'
require_relative 'noose'
require_relative 'solution'

# Hangman game
class Hangman
  def initialize
    restore
    @solution ||= Solution.new
    @noose ||= Noose.new
    play
  end

  private

  def play
    turn until @solution.solved? || @noose.hung?
    output_result
  end

  def turn
    @noose.show
    menu
    @noose.lose_life unless @solution.guess
  end

  def output_result
    return @solution.success if @solution.solved?

    @noose.failure
    @solution.failure
  end

  def restore
    return unless File.exist?('saved.dat')

    puts "\nWould you like to restore a saved game? (y/n)"
    return unless gets.chomp.downcase == 'y'

    parse_saved_game
  end

  def parse_saved_game
    data = JSON.parse(File.read('saved.dat'))
    puts "\nGame restored".green
    @solution = Solution.from_hash(data['@solution'])
    @noose = Noose.from_hash(data['@noose'])
  rescue JSON::ParserError
    puts "\nOoops! The saved game was corrupted.".red
    puts "\nMENU\n1 - Quit\n2 - Continue with new game"
    return unless gets.chomp == '1'

    quit
  end

  def menu
    puts "\nMENU\n1 - Save & Quit\n2 - Guess a letter"
    return unless gets.chomp == '1'

    save_and_quit
  end

  def save_and_quit
    File.open('saved.dat', 'w') do |file|
      file.print JSON.pretty_generate(to_hash)
    end
    puts "\nGame saved".green
    quit
  end

  def quit
    puts "\nGoodbye!"
    puts
    exit
  end

  def to_hash
    {
      '@solution': @solution.to_hash,
      '@noose': @noose.to_hash
    }
  end
end

# ENTRYPOINT
Hangman.new
