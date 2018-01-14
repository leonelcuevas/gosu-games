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


  def handle_mouse_down(x, y)
    @start_square = get_square(x, y)
  end


  def handle_mouse_up(x, y)
    @end_square = get_square(x, y)
    return unless @start_square and @end_square
    move() if is_move_valid?(@start_square, @end_square)
    @start_square = nil
  end
  
  
  def get_square(x, y) # x and y are pixel units
    row = (y.to_i - 20) / 100
    col = (x.to_i - 20) / 100
    get_square_cr(col, row)
  end


  def get_square_cr(col, row)
    return nil if row < 0 or row > 5 or col < 0 or col > 5
    @squares[6 * row + col]
  end

  def squares_between_in_row(square1, square2)
    sqrs = []
    row = square1.row
    col_start = square1.column
    col_end = square2.column
    # swap them if start is bigger than end
    col_start, col_end = col_end, col_start if col_start > col_end
    # add them to the final array
    (col_start..col_end).each { |col| sqrs.push(get_square_cr(col, row)) }
    sqrs
  end


  def squares_between_in_col(square1, square2)
    sqrs = []
    col = square1.column
    row_start = square1.row
    row_end = square2.row
    # swap them if start is bigger than end
    row_start, row_end = row_end, row_start if row_start > row_end
    # add them to the final array
    (row_start..row_end).each { |row| sqrs.push(get_square_cr(col, row)) }
    sqrs
  end


  def is_move_valid?(square1, square2)
		return false if square1.number == 0
    if square1.row == square2.row
      @squares_between = squares_between_in_row(square1, square2)
    elsif square1.column == square2.column
      @squares_between = squares_between_in_col(square1, square2)
    else
      return false
    end
    @squares_between.reject!{|square| square.number == 0}
    return false if @squares_between.count != 2
    return false if @squares_between[0].color != @squares_between[1].color
    true  
  end


  def move
    color = @squares_between[0].color
    number = @squares_between[0].number + @squares_between[1].number
    @squares_between[0].clear
    @squares_between[1].clear
    @end_square.set(color, number)
  end


end
