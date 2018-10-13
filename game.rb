require 'gosu'
require_relative 'lib/settings'
require_relative 'lib/image'
require_relative 'lib/brick'
require_relative 'lib/bricks'
require_relative 'lib/paddle'
require_relative 'lib/ball'

class Game < Gosu::Window
  PADDLE_X_START = (Settings::SCREEN_WIDTH / 2) - (Settings::PADDLE_WIDTH / 2)
  PADDLE_Y_START = Settings::SCREEN_HEIGHT - Settings::PADDLE_HEIGHT
  MEDIUM_BALL_X_START = (Settings::SCREEN_WIDTH / 2) - (Ball::REGULAR_BALL_AREA / 2)
  MEDIUM_BALL_Y_START = Settings::SCREEN_HEIGHT - Settings::PADDLE_HEIGHT - Ball::REGULAR_BALL_AREA
  SMALL_BALL_X_START = (Settings::SCREEN_WIDTH / 2) - (Ball::SMALL_BALL_AREA / 2)
  SMALL_BALL_Y_START = Settings::SCREEN_HEIGHT - Settings::PADDLE_HEIGHT - Ball::SMALL_BALL_AREA

  def initialize
    super(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
    self.caption = 'Brick Breaker'
    load_graphics
    @game_state = :ball_in_paddle
    @score = 0
    @lives = 3
    @font = Gosu::Font.new(20)
  end

  def update
    button_pressed
    ball_movements
    collisions
    @game_state = :won if won?
  end

  def draw
    @background.draw(0, 0, 0)
    @bricks.each { |brick| brick.image.draw(brick.position.first, brick.position.last, 0) }
    @paddle.image.draw(@paddle.position.first, @paddle.position.last, 0)
    @balls.each { |ball| ball.image.draw(ball.position.first, ball.position.last, 0) }
    @font.draw("Score: #{@score.to_s}", 20, 460, 0, 1, 1, Gosu::Color::WHITE)
    @font.draw("Lives: #{@lives.to_s}", 520, 460, 0, 1, 1, Gosu::Color::WHITE)
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
    @paddle = Paddle.new(file: 'assets/paddle_simple.png', position: [PADDLE_X_START, PADDLE_Y_START])
  end

  def load_ball
    @balls = []
    @balls << Ball.new(file: 'assets/ball_regular.png', position: [MEDIUM_BALL_X_START, MEDIUM_BALL_Y_START])
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

  def ball_movements
    @balls.each(&:move) if @game_state == :playing
    @balls.each(&:boundary_bounce) if @game_state == :playing
    ball_lost
    end

  def ball_lost
    if @balls.size == 1
      if @balls.first.lost?
        @lives -= 1 if @lives.positive?
        return @game_state = :game_over if @lives.zero?

        @game_state = :ball_in_paddle
        reset_paddle
        reset_ball
      end
    else
      @balls.each do |ball|
        @balls.delete ball if ball.lost?
      end
    end
  end

  def reset_paddle
    @paddle.position = [PADDLE_X_START, PADDLE_Y_START]
  end

  def reset_ball
    if @balls.first.area == 16
      @balls.first.position = [MEDIUM_BALL_X_START, MEDIUM_BALL_Y_START]
    elsif @balls.first.area == 8
      @balls.first.position = [SMALL_BALL_X_START, SMALL_BALL_Y_START]
    end
  end

  def collisions
    brick_collision
    paddle_collision if @game_state != :ball_in_paddle
  end

  def brick_collision
    @bricks.each do |brick|
      @balls.each do |ball|
        next unless ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)

        ball.bounce_off
        destroy_brick(brick)
      end
    end
  end

  def destroy_brick(brick)
    @score += brick.value
    @bricks.delete brick
  end

  def paddle_collision
    @balls.each do |ball|
      next unless ball.collides_with?(@paddle.position, Settings::PADDLE_WIDTH, Settings::PADDLE_HEIGHT)

      ball.reposition_to(@paddle.position[1], Settings::PADDLE_HEIGHT)
      ball.bounce_off
    end
  end

  def won?
    @bricks.size.zero?
  end

  def button_pressed
    if Gosu.button_down?(Gosu::KB_LEFT)
      @paddle.move_left
      @balls.each(&:move_left) if @game_state == :ball_in_paddle
    elsif Gosu.button_down?(Gosu::KB_RIGHT)
      @paddle.move_right
      @balls.each(&:move_right) if @game_state == :ball_in_paddle
    elsif Gosu.button_down?(Gosu::KB_SPACE)
      if @game_state == :ball_in_paddle
        @balls.each(&:lift_off)
        @game_state = :playing
      end
    end
  end
end

Game.new.show
