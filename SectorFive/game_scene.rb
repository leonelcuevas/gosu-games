require 'gosu'
require_relative 'bullet'
require_relative 'enemy'
require_relative 'explosion'
require_relative 'player'

class GameScene
  ENEMY_FREQUENCY = 0.025
  MAX_ENEMIES = 100

  def initialize(window)
    @player = Player.new(window)
    @bullets = []
    @enemies = []
    @explosions = []
    @enemies_appeared = 0
    @enemies_destroyed = 0
    @window = window

    # load and start background music and sound effects
    @music = Gosu::Song.new('sounds/Cephalopod.ogg')
    @music.play(true)
    
    @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
    @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
  end

  def update
    @player.turn_left if @window.button_down?(Gosu::KbLeft)
    @player.turn_right if @window.button_down?(Gosu::KbRight)
    @player.accelerate if @window.button_down?(Gosu::KbUp)
    @player.accelerate(false) if @window.button_down?(Gosu::KbDown)
    @player.move 
    if rand < ENEMY_FREQUENCY
      @enemies.push(Enemy.new(@window))
      @enemies_appeared += 1
    end
    @enemies.each { |enemy| enemy.move }
    @bullets.each { |bullet| bullet.move }

    # collision detection bullets - enemies
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete enemy
          @bullets.delete bullet
          @explosions.push(Explosion.new(@window, enemy.x, enemy.y))
          @enemies_destroyed += 1
          @explosion_sound.play
        end
      end
    end

    # clean array from finished and  out of view objetcs
    @explosions.dup.each { |exp| @explosions.delete(exp) if exp.finished }
    @enemies.dup.each { |e| @enemies.delete(e) if e.y > @window.height + e.radius }
    @bullets.dup.each { |b| @bullets.delete(b) unless b.on_screen? }

    # check for end game conditions
    # max enemies reached
    event = { :enemies_destroyed => @enemies_destroyed, :cause => nil }

    event[:cause] = :max_enemies if @enemies_appeared > MAX_ENEMIES
    
    # player abduted by mother ship (top bound)
    event[:cause] = :mother_ship if @player.y < -@player.radius
      
    # player is hit by enemy ship
    @enemies.each do |enemy|
      distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
      event[:cause] = :hit_by_enemy if distance < @player.radius + enemy.radius
    end

    # if any event happend change scene
    @window.change_scene(:end, event) if event[:cause] != nil
  end

  def draw
    @player.draw
    @enemies.each { |enemy| enemy.draw }
    @bullets.each { |bullet| bullet.draw }
    @explosions.each { |exp| exp.draw }
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push(Bullet.new(@window, @player.x, @player.y, @player.angle))
      @shooting_sound.play(0.3)
    end
  end
end
