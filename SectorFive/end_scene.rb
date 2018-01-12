class EndScene
  def initialize(window, event)
    @window = window
    cause = event[:cause]
    enemies_destroyed = event[:enemies_destroyed]

    # set top part message depending on event that triggered the end game
    case cause
    when :max_enemies
      @top_message1 = "You made it!  You destroyed #{enemies_destroyed} ships"
      @top_message2= "and #{100 - enemies_destroyed} reached the base."
    when :mother_ship
      @top_message1 = "You got too close to the enemy mother ship."  
      @top_message2 = "Before your ship was destroyed, you took out #{enemies_destroyed} enemy ships."
    when :hit_by_enemy
      @top_message1 = "You were struck by an enemy ship."
      @top_message2 = "Before your ship was destroyed, you took out #{enemies_destroyed} enemy ships."
    end

    @bottom_message = "Press P to play again, or Q to quit."
    @message_font = Gosu::Font.new(28)

    # setup credits, each line is an independent Gosu text
    @credits = []
    y = 550
    File.open('text/credits.txt').each do |line|
      @credits.push(CreditLine.new(@window, line.chomp, 100, y)) # fixed x = 100
      y += 30 # make each line appear below the others
    end

    # load and start background music
    @music = Gosu::Song.new('sounds/FromHere.ogg')
    @music.play(true)
  end

  def update
		@credits.each { |c| c.move }
		@credits.each { |c| c.reset } if @credits.last.y < 150
  end

  def draw
    #draw scrolling credits
    @window.clip_to(50, 140, 700, 360) do # only draws inside this window (x,y,w,h)
      @credits.each { |c| c.draw }
    end

    # draw messages and separators
		@window.draw_line(0, 140, Gosu::Color::RED, @window.width, 140, Gosu::Color::RED)
    @message_font.draw(@top_message1, 40, 40, 1, 1, 1, Gosu::Color::FUCHSIA)
    @message_font.draw(@top_message2, 40, 75, 1, 1, 1, Gosu::Color::FUCHSIA)
    @window.draw_line(0, 500, Gosu::Color::RED, @window.width, 500, Gosu::Color::RED)
    @message_font.draw(@bottom_message, 180, 540, 1, 1, 1, Gosu::Color::AQUA)
  end

  def button_down(id)
    if id == Gosu::KbP
      @window.change_scene(:game)
    elsif id == Gosu::KbQ
      @window.close
    end
  end

end
