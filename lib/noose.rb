# frozen_string_literal: true

require 'colorize'

# Noose class
class Noose
  LIVES = 7

  def initialize(lives_lost = 0)
    @lives_lost = lives_lost
  end

  def lose_life
    @lives_lost += 1
  end

  def hung?
    @lives_lost == LIVES
  end

  def show
    draw ->(str) { puts str.black.on_white.bold }
  end

  def failure
    draw ->(str) { puts str.white.on_red.bold }
    puts 'Bad luck! You failed!'.red.bold
  end

  def to_hash
    { '@lives_lost': @lives_lost }
  end

  class << self
    def from_hash(hash)
      new(hash['@lives_lost'])
    end
  end

  private

  def draw(proc)
    puts
    rows.each { |str| proc.call(str) }
    puts
  end

  def rows
    [
      %(#{' '.ljust(10, '_')}   ),
      %(|#{(@lives_lost.positive? ? '|' : '').rjust(10)}  ),
      %(|#{(@lives_lost > 1 ? 'O' : '').rjust(10)}  ),
      %(|#{midriff.rjust(11)} ),
      %(|#{legs.rjust(11)} ),
      '|'.ljust(13),
      '|'.ljust(13),
      ''.ljust(13)
    ]
  end

  def midriff
    case @lives_lost
    when (0..2) then ''
    when 3 then '| '
    when 4 then '/| '
    else '/|\\'
    end
  end

  def legs
    case @lives_lost
    when (0..5) then ''
    when 6 then '/  '
    when 7 then '/ \\'
    end
  end
end
