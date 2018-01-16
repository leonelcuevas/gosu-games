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

    if game_over?
      c = Gosu::Color.argb(0x33000000)
      @window.draw_quad(0, 0, c, 640, 0, c, 640, 640, c, 0, 640, c, 4)
      @font.draw('Game Over', 230, 240, 5)
      @font.draw('Press CTRL-R to Play Again', 205, 320, 5, 0.6, 0.6)
    end

    return unless @start_square
    @start_square.highlight(:start)
    return unless @current_square and @current_square != @start_square
    if is_move_valid?(@start_square, @current_square)
      @current_square.highlight(:legal)
    else
      @current_square.highlight(:illegal)
    end
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


  def handle_mouse_move(x, y)
    @current_square = get_square(x, y)
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


  def legal_move_for?(start_square)
    return false if start_square.number == 0
    @squares.any? { |end_square| is_move_valid?(start_square, end_square) }
  end


  def game_over?
    @squares.none? { |sqr| legal_move_for?(sqr) }
  end

end
