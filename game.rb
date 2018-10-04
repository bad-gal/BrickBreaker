require 'gosu'

class Game < Gosu::Window
  def initialize
    super(640, 480)
    self.caption = "Brick Breaker"
  end

  def update; end

  def draw; end
end

Game.new.show
