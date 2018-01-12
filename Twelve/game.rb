require_relative 'square'

class Game
  def initialize(window)
    @window = window
    Square.set_window(window)

    @squares = []
    color_list =[]

    [:red, :green, :blue].each do |color|
      12.times { color_list.push(color) }
    end
    color_list.shuffle!

    (0..5).each do |row|
      (0..5).each do |col|
        i = row * 6 + col
        @squares.push(Square.new(col, row, color_list[i]))
      end
    end

    @font = Gosu::Font.new(36)
  end

  def draw
    @squares.each { |s| s.draw }
  end
end
