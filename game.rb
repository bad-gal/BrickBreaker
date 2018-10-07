require 'gosu'
require_relative 'lib/settings'
require_relative 'lib/image'
require_relative 'lib/brick'
require_relative 'lib/bricks'
require_relative 'lib/paddle'
require_relative 'lib/ball'


class Game < Gosu::Window
  def initialize
    super(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
    self.caption = 'Brick Breaker'
    load_graphics
  end

  def update
    @paddle.move_left if Gosu.button_down?(Gosu::KB_LEFT)
    @paddle.move_right if Gosu.button_down?(Gosu::KB_RIGHT)
  end

  def draw
    @background.draw(0, 0, 0)
    @bricks.each do |brick|
      brick.image.draw(brick.position.first, brick.position.last, 0)
    end
    @paddle.image.draw(@paddle.position.first, @paddle.position.last, 0)
    @ball.image.draw(@ball.position.first, @ball.position.last, 0)
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end

  private

  def load_graphics
    @background = Gosu::Image.new('assets/background.png')
    load_bricks
    load_paddle
    load_ball
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
    position_bricks(x: 0, y: -Settings::BRICK_HEIGHT)
  end

  def load_paddle
    x = (Settings::SCREEN_WIDTH / 2) - (Settings::BRICK_WIDTH / 2)
    y = Settings::SCREEN_HEIGHT - Settings::BRICK_HEIGHT
    @paddle = Paddle.new(file: 'assets/paddle_simple.png', position: [x, y])
  end

  def load_ball
    x = (Settings::SCREEN_WIDTH / 2) - (16 / 2)
    y = Settings::SCREEN_HEIGHT - Settings::BRICK_HEIGHT - 16
    @ball = Ball.new(file: 'assets/ball_regular.png', position: [x, y])
  end

  def position_bricks(x:, y:)
    @bricks.each_with_index do |brick, i|
      if (i % Settings::BRICKS_PER_ROW).zero?
        x = 0
        y += Settings::BRICK_HEIGHT
      else
        x += Settings::BRICK_WIDTH
      end
      brick.position = [x, y]
    end
  end
end

Game.new.show
