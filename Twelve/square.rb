require 'gosu'

class Square
  SIZE = 100
  OFFSET = 22
  MARGIN = 2
  FONT_SIZE = 72

  @@colors  = { red: Gosu::Color.argb(0xaaff0000),
                green: Gosu::Color.argb(0xaa00ff00),
                blue: Gosu::Color.argb(0xaa0000ff)}
  @@font = Gosu::Font.new(FONT_SIZE)
  @@window = nil

  attr_reader :row, :column, :number, :color

  def self.set_window(window)
    @@window = window
  end

  def initialize(column, row, color)
    @row = row
    @column = column
    @color = color
    @number = 1
  end

  def draw
    return if @number == 0
    
    s = SIZE - 2*MARGIN # size without margins
    
    # calculate square corners
    x1 = OFFSET + @column * SIZE
    y1 = OFFSET + @row * SIZE
    x2 = x1 + s
    y2 = y1
    x3 = x2
    y3 = y2 + s
    x4 = x1
    y4 = y3
    c = @@colors[@color]
    @@window.draw_quad(x1, y1, c, x2, y2, c, x3, y3, c, x4, y4, c, 2)

    # get text position
    x_center = x1 + s/2
    y_center = y1 + s/2
    x_text = x_center - @@font.text_width("#{@number}") / 2
    y_text = y_center - FONT_SIZE / 2.5 # found empirically
    @@font.draw("#{@number}", x_text, y_text, 1)
  end

end
