require 'gosu'

require_relative 'bullet'
require_relative 'credit_line'
require_relative 'enemy'
require_relative 'explosion'
require_relative 'player'

require_relative 'end_scene'
require_relative 'game_scene'
require_relative 'start_scene'

class SectorFive < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Sector Five'
    @scene = StartScene.new(self)
  end

  def update
    @scene.update
  end

  def draw
    @scene.draw
  end

  def button_down(id)
    @scene.button_down(id)
  end

  def change_scene(type, event = nil)
    case type
    when :end
      @scene = EndScene.new(self, event)
    when :game
      @scene = GameScene.new(self)
    when :start
      @scene = StartScene.new(self)
    end
  end
end

window = SectorFive.new
window.show
