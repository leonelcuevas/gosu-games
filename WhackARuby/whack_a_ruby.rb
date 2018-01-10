require 'gosu'

# Gosu::Window is the base class for gosu applications
class WhackARuby < Gosu::Window

  # init variables runs only once at the beginning
  def initialize
    super(800,600)
    self.caption = "Whack the Ruby!"

    # ruby sprite variables
    @image = Gosu::Image.new('ruby.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 3
    @velocity_y = 3
    @visible = 0 # timer to control if ruby appears on screen (> 0) or not (<= 0)

    @hammer = Gosu::Image.new('hammer.png')
    @hit = 0  # boolean if last time hit or not
    @score = 0 # total score of the game
    @font = Gosu::Font.new(30) # font used for time and score
    @playing = true # boolean to control game over
    @start_time = 0
  end


  # update variables, runs once every frame
  def update
    return unless @playing # do nothing if not playing

    @x += @velocity_x
    @y += @velocity_y
    @visible -= 1 # substract 1 from the visible timer
    @time_left = (30 - ((Gosu.milliseconds - @start_time) / 1000)) # timer to control game (30 s)
    @playing = false if @time_left < 0 # if time < 0 finish game (not playing)

    # ruby bounces on screen edges
    @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width / 2 < 0
    @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height / 2 < 0

    # ruby has a 0.01 percent chance of reapearing after turning invisible for 10 frames
    @visible = 100 if @visible < -10 and rand < 0.01
  end


  # controls mouse and keyboard input
  def button_down(id)
    if @playing # if playing expects a mouse click to hit ruby
      if (id == Gosu::MsLeft)
        # if click was close enough to ruby sprite (@x, @y)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          # mark it as hit and increase score
          @hit = 1 
          @score += 5
        else
          # else mark it as no hit and decrease score
          @hit = -1
          @score -= 1
        end
      end
    else # if not playing expects a space key to restart game
      if (id == Gosu::KbSpace)
        # game control variables for knwoing if playing, time left, ruby visible and score
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds # new start time
        @score = 0
      end
    end
  end


  # draw the images, runs once every frame
  def draw
    # draw ruby if visible
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end

    # always draw hammer
    @hammer.draw(mouse_x - 40, mouse_y - 10, 1)

    # on a click the screen flashes green or red (hit or fail)
    if @hit == 0
      c = Gosu::Color::NONE # otherwhise it doesn't do it
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    # draw square for flahing effect ofn teh wholse screen and reset hit variable
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0

    # draw time lift and score all the time
    @font.draw(@time_left.to_s, 20, 20, 2)
    @font.draw(@score.to_s, 700, 20, 2)

    # whe game is done draw game over messages and ruby
    unless @playing
       @font.draw('Game Over', 300, 300, 3)
       @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
       @visible = 20
    end
  end
end

# instantiate game window and show it
window = WhackARuby.new
window.show
