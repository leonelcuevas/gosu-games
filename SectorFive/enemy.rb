class Enemy
  SPEED = 2
  attr_reader :x, :y, :radius

  def initialize(window)
    @y = 0
    @radius = 20
    @image = Gosu::Image.new('images/enemy.png')
    @x = rand(window.width - 2 * @radius) + @radius
  end

  def move
    @y+= SPEED
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

end
