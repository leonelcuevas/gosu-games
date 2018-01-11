class Explosion
  attr_reader :finished
  
  def initialize(window, x, y)
    @x = x
    @y = y
    @radius = 30
    @image_index = 0
    @finished = false
    
    # load 60 x 60 images from sprite sheet
    @images = Gosu::Image.load_tiles('images/explosions.png', 60, 60)
  end

  def draw
    if @image_index < @images.count
      @images[@image_index].draw(@x - @radius, @y - @radius, 2)
      @image_index += 1
    else
      @finished = true
    end
  end

end
