class StartScene
  def initialize(window)
    @background = Gosu::Image.new('images/start_screen.png')
    @window = window
  end

  def update
  end

  def draw
    @background.draw(0, 0, 0)
  end

  def button_down(id)
    @window.change_scene(:game)
  end

end
