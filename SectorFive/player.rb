class Player
  ACCELERATION = 2
  FRICTION = 0.9
  ROTATION_SPEED = 3
  attr_reader :x, :y, :angle, :radius

  def initialize(window)
    @x = 200
    @y = 200
    @angle = 0
    @image = Gosu::Image.new('images/ship.png')
    @vel_x = 0
    @vel_y = 0
    @radius = 20
    @window = window
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @vel_x *= FRICTION
    @vel_y *= FRICTION

    if @x > @window.width - @radius
      @vel_x = 0
      @x = @window.width - @radius
    end

    if @x < @radius
      @vel_x = 0
      @x = @radius
    end

    if @y > @window.height - @radius
      @vel_y = 0
      @y = @window.height - @radius
    end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_left
    @angle -= ROTATION_SPEED
  end

  def turn_right
    @angle += ROTATION_SPEED
  end

  def accelerate(positive = true)
    acc = (positive)? ACCELERATION : -ACCELERATION 
    @vel_x += Gosu.offset_x(@angle, acc)
    @vel_y += Gosu.offset_y(@angle, acc)
  end

end
