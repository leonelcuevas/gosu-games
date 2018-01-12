require 'gosu'
require_relative 'game'

class Twelve < Gosu::Window
  WIDTH = 640
  HEIGHT = 640

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Twelve'
    @game = Game.new(self)
  end

  def draw
    @game.draw
  end
end

window = Twelve.new
window.show
