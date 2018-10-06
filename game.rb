require 'gosu'
require_relative 'lib/image'
require_relative 'lib/brick'
require_relative 'lib/bricks'
require_relative 'lib/paddle'


class Game < Gosu::Window
  SCREEN_WIDTH = 640
  SCREEN_HEIGHT = 480
  BRICK_WIDTH = 80
  BRICK_HEIGHT = 16
  BRICKS_PER_ROW = 640 / 80

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Brick Breaker'
    load_graphics
  end

  def update; end

  def draw
    @background.draw(0, 0, 0)
    @bricks.each do |brick|
      brick.image.draw(brick.position.first, brick.position.last, 0)
    end
    @paddle.image.draw(@paddle.position.first, @paddle.position.last, 0)
  end

  private

  def load_graphics
    @background = Gosu::Image.new('assets/background.png')
    load_bricks
    load_paddle
  end

  def load_bricks
    blue_bricks = { size: 8, file: 'assets/brick_blue.png', value: 600 }
    pink_bricks = { size: 16, file: 'assets/brick_pink.png', value: 500 }
    green_bricks = { size: 16, file: 'assets/brick_green.png', value: 400 }
    orange_bricks = { size: 16, file: 'assets/brick_orange.png', value: 300 }
    purple_bricks = { size: 16, file: 'assets/brick_purple.png', value: 200 }
    red_bricks = { size: 16, file: 'assets/brick_red.png', value: 100 }
    @bricks = Bricks.new(blue_bricks, pink_bricks, green_bricks, orange_bricks,
                         purple_bricks, red_bricks).pile
    position_bricks(x: 0, y: -BRICK_HEIGHT)
  end

  def load_paddle
    x = (SCREEN_WIDTH / 2) - (BRICK_WIDTH / 2)
    y = SCREEN_HEIGHT - BRICK_HEIGHT
    @paddle = Paddle.new(file: 'assets/paddle_simple.png', position: [x, y])
  end

  def position_bricks(x:, y:)
    @bricks.each_with_index do |brick, i|
      if (i % BRICKS_PER_ROW).zero?
        x = 0
        y += BRICK_HEIGHT
      else
        x += BRICK_WIDTH
      end
      brick.position = [x, y]
    end
  end
end

Game.new.show
