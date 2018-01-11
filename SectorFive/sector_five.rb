require 'gosu'
require_relative 'bullet'
require_relative 'enemy'
require_relative 'explosion'
require_relative 'player'

class SectorFive < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  ENEMY_FREQUENCY = 0.025

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)
    @bullets = []
    @enemies = []
    @explosions = []
  end

  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.accelerate(false) if button_down?(Gosu::KbDown)
    @player.move
    @enemies.push(Enemy.new(self)) if rand < ENEMY_FREQUENCY
    @enemies.each { |enemy| enemy.move }
    @bullets.each { |bullet| bullet.move }

    # collision detection bullets - enemies
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete enemy
          @bullets.delete bullet
          @explosions.push(Explosion.new(self, enemy.x, enemy.y))
        end
      end
    end

    @explosions.dup.each { |exp| @explosions.delete(exp) if exp.finished }
    @enemies.dup.each { |e| @enemies.delete(e) if e.y > HEIGHT + e.radius }
    @bullets.dup.each { |b| @bullets.delete(b) unless b.on_screen? }
  end

  def draw
    @player.draw
    @enemies.each { |enemy| enemy.draw }
    @bullets.each { |bullet| bullet.draw }
    @explosions.each { |exp| exp.draw }
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push(Bullet.new(self, @player.x, @player.y, @player.angle))
    end
  end
end

window = SectorFive.new
window.show
