require 'gosu'
require_relative 'lib/settings'
require_relative 'lib/image'
require_relative 'lib/brick'
require_relative 'lib/paddle'
require_relative 'lib/ball'
require_relative 'lib/capsule'

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
    @large_font = Gosu::Font.new(120)
  end

  def update
    button_pressed
    ball_movements
    collisions
    @game_state = :won if won?
    @game_state = :game_over if @lives.zero? && !won?
  end

  def draw
    @background.draw(0, 0, 0)
    @bricks.each do |brick|
      brick.capsule.image.draw(brick.capsule.position.first, brick.capsule.position.last, 0)
      brick.image.draw(brick.position.first, brick.position.last, 0)
    end
    @paddle.image.draw(@paddle.position.first, @paddle.position.last, 0)
    @balls.each { |ball| ball.image.draw(ball.position.first, ball.position.last, 0) }
    @font.draw("Score: #{@score}", 20, 460, 0, 1, 1, Gosu::Color::WHITE)
    @font.draw("Lives: #{@lives}", 520, 460, 0, 1, 1, Gosu::Color::WHITE)

    if @game_state == :game_over
      @large_font.draw('Game Over', 50, 160, 0, 1, 1, Gosu::Color::WHITE)
    elsif @game_state == :won
      @large_font.draw('You won', 50, 160, 0, 1, 1, Gosu::Color::WHITE)
    end

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
    load_balls
  end

  def load_bricks
    @bricks = []

    blue_bricks = { size: 8, file: 'assets/brick_blue.png', value: 60 }
    pink_bricks = { size: 16, file: 'assets/brick_pink.png', value: 50 }
    green_bricks = { size: 16, file: 'assets/brick_green.png', value: 40 }
    orange_bricks = { size: 16, file: 'assets/brick_orange.png', value: 30 }
    purple_bricks = { size: 16, file: 'assets/brick_purple.png', value: 20 }
    red_bricks = { size: 16, file: 'assets/brick_red.png', value: 10 }

    variants = [blue_bricks, pink_bricks, green_bricks, orange_bricks, purple_bricks, red_bricks]
    variants.each do |var|
      size = var[:size]
      1.upto(size) do
        @bricks << Brick.new(file: var[:file], value: var[:value], position: [0, 0])
      end
    end

    position_bricks(x: 0, y: -Settings::BRICK_HEIGHT)
    attach_capsules
  end

  def load_paddle
    @paddle = Paddle.new(details: Paddle::REGULAR_PADDLE)
    position_paddle
  end

  def load_balls
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
      brick.capsule.position = [x, y]
    end
  end

  def attach_capsules
    sample = @bricks.sample(9)

    sample.each_with_index do |brick, i|
      x_diff = (Settings::BRICK_WIDTH - brick.capsule.width) / 2
      brick.capsule = Capsule.new(type: Capsule::CAPSULES[i],
                                  position: [brick.position[0] + x_diff, brick.position[1]])
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
        return if @lives.zero?

        @game_state = :ball_in_paddle
        reset_paddle
        position_paddle
        reset_ball
      end
    else
      @balls.each do |ball|
        @balls.delete ball if ball.lost?
      end
    end
  end

  def position_paddle
    x = (Settings::SCREEN_WIDTH / 2) - (@paddle.width / 2)
    y = Settings::SCREEN_HEIGHT - @paddle.height
    @paddle.position = [x, y]
  end

  def reset_ball
    if @balls.first.area == 16
      @balls.first.position = [MEDIUM_BALL_X_START, MEDIUM_BALL_Y_START]
    elsif @balls.first.area == 8
      @balls.first.position = [SMALL_BALL_X_START, SMALL_BALL_Y_START]
    end
  end

  def reset_paddle
    @paddle.change(details: Paddle::REGULAR_PADDLE)
  end

  def collisions
    brick_collision
    paddle_collision if @game_state != :ball_in_paddle
    capsule_collision
  end

  def brick_collision
    @bricks.each do |brick|
      @balls.each do |ball|
        next unless ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)

        ball.bounce_off
        cull_brick(brick)
      end
    end
  end

  def cull_brick(brick)
    @score += brick.value
    brick.destroy
    @bricks.delete(brick) if brick.capsule.type == :empty
  end

  def paddle_collision
    @balls.each do |ball|
      next unless ball.collides_with?(@paddle.position, Settings::PADDLE_WIDTH, Settings::PADDLE_HEIGHT)

      ball.reposition_to(@paddle.position[1], Settings::PADDLE_HEIGHT)
      ball.bounce_off
    end
  end

  def capsule_collision
    @bricks.each do |brick|
      next unless brick.capsule.visible

      brick.capsule.fall
      if brick.capsule.collides_with?(@paddle.position, @paddle.width, @paddle.height)
        brick.capsule.visible = false
        collect_gift(brick.capsule.type)
        @bricks.delete brick
      elsif brick.capsule.position[1] > Settings::SCREEN_HEIGHT
        @bricks.delete brick
      end
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

  def collect_gift(type)
    method(type).call
  end

  def score_250
    @score += 250
  end

  def score_100
    @score += 100
  end

  def score_500
    @score += 500
  end

  def small_paddle
    @score += 75
    @paddle.change(details: Paddle::SMALL_PADDLE)
  end

  def large_paddle
    @score += 75
    @paddle.change(details: Paddle::LONG_PADDLE)
  end

  def extra_life
    @score += 75
    @lives += 1 if @lives < 5
  end

  def slow_ball
    @score += 75
    @balls.each do |ball|
      ball.velocity[0].positive? ? ball.velocity[0] -= 2 : ball.velocity[0] += 2
      ball.velocity[0].positive? ? ball.velocity[1] -= 2 : ball.velocity[1] += 2
    end
  end

  def fast_ball
    @score += 75
    @balls.each do |ball|
      ball.velocity[0].positive? ? ball.velocity[0] += 3 : ball.velocity[0] -= 3
      ball.velocity[0].positive? ? ball.velocity[1] += 3 : ball.velocity[1] -= 3
    end
  end

  def multi
    @score += 75
    @balls << Ball.new(file: 'assets/ball_regular.png', position: [MEDIUM_BALL_X_START, MEDIUM_BALL_Y_START])
    @balls << Ball.new(file: 'assets/ball_regular.png', position: [MEDIUM_BALL_X_START, MEDIUM_BALL_Y_START])
  end
end

Game.new.show
