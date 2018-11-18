require 'gosu'
require_relative 'lib/state'
require_relative 'lib/settings'
require_relative 'lib/level_manager'
require_relative 'lib/image'
require_relative 'lib/paddle'
require_relative 'lib/ball'
require_relative 'lib/capsule'
require_relative 'lib/brick'
require_relative 'lib/bullet'

class Game < Gosu::Window
  FAST_BALL = 6
  SLOW_BALL = 2
  MAX_BULLETS = 10

  def initialize
    super(Settings::SCREEN_WIDTH, Settings::GAME_HEIGHT)
    self.caption = 'Breakout'
    initial_game_values
    load_graphics
    font_values
  end

  private

  def update
    unless @game_state == State::WON
      button_pressed
      ball_movements
      collisions
      update_bullets
      update_bricks
      flash_screen
    end
    @game_state = State::WON if won?
    @game_state = State::GAME_OVER if @lives.zero? && !won?
  end

  def draw
    static_draw
    draw_game_objects
    draw_score_board
    draw_info
    end

  def initial_game_values
    @level = 1
    @score = 0
    @lives = 3
    @game_state = State::BALL_IN_PADDLE
    @bullets = []
    reset_bullets
  end

  def load_graphics
    @background = Gosu::Image.new('assets/background.png')
    @border = Gosu::Image.new('assets/border.png')
    background_settings
    load_paddle
    load_balls
    level = 'level_' + @level.to_s
    @bricks = LevelManager.method(level).call
  end

  def font_values
    @font = Gosu::Font.new(25)
    @large_font = Gosu::Font.new(120)
  end

  def background_settings
    @bkgnd_colour = Gosu::Color::WHITE
    @bkgnd_timer = 0
  end

  def flash_screen
    return unless @bkgnd_timer.positive?

    change_background_colour
  end

  def change_background_colour
    if (@bkgnd_timer + 250) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::GREEN
    elsif (@bkgnd_timer + 500) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::WHITE
    elsif (@bkgnd_timer + 750) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::GREEN
    elsif (@bkgnd_timer + 100) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::WHITE
    elsif (@bkgnd_timer + 1250) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::GREEN
    elsif (@bkgnd_timer + 1500) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::WHITE
    elsif (@bkgnd_timer + 1750) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::GREEN
    elsif (@bkgnd_timer + 2000) > Gosu.milliseconds
      @bkgnd_colour = Gosu::Color::WHITE
      @bkgnd_timer = 0
    end
  end

  def static_draw
    @background.draw(0, 0, 0, 1, 1, color = @bkgnd_colour)
    @border.draw(640, 0, 0, 1, 1, color = Gosu::Color::WHITE, mode = :additive)
  end

  def draw_game_objects
    @bricks.each do |brick|
      brick.capsule.draw
      brick.draw
    end
    @paddle.draw
    @balls.each(&:draw)
    @bullets.each(&:draw) unless @bullets.empty?
  end

  def ball_movements
    @balls.each(&:move)
    @balls.each(&:boundary_bounce)
    ball_lost
  end

  def ball_lost
    if @balls.size == 1
      manage_lost_ball
    else
      @balls.each do |ball|
        @balls.delete ball if ball.lost?
      end
    end
  end

  def manage_lost_ball
    return unless @balls.first.lost?

    @lives -= 1 if @lives.positive?
    return if @lives.zero?

    @game_state = State::BALL_IN_PADDLE
    @paddle.reset
    reset_bullets
    reset_only_ball
  end

  def reset_only_ball
    @balls.first.reset(pos_x: @paddle.position[:x] + (@paddle.width / 2) - 8, pos_y: @paddle.position[:y] - @paddle.height)
  end

  def collisions
    paddle_collisions
    brick_collision
    bullet_collision
  end

  def paddle_collisions
    @balls.each do |ball|
      next unless ball.collides_with?(@paddle.position, @paddle.width, @paddle.height)

      ball.reposition_to(@paddle.position[:y], @paddle.height)
      ball.change_velocity_x(@paddle.position, @paddle.width)
      ball.bounce_off
    end
  end

  def brick_collision
    @bricks.each do |brick|
      handle_ball(brick)
    end
  end

  def handle_ball(brick)
    @balls.each do |ball|
      next unless ball.collides_with?(brick.position, Brick::BRICK_WIDTH, Brick::BRICK_HEIGHT)

      act_on_ball_collision(ball, brick)
    end
  end

  def act_on_ball_collision(ball, brick)
    ball.velocity[:y] = -ball.velocity[:y]
    change_ball_velocity(ball, brick)
    brick.damage
    cull(brick) if brick.hits.zero?
  end

  def change_ball_velocity(ball, brick)
    return unless ball.collides_with?(brick.position, Brick::BRICK_WIDTH, Brick::BRICK_HEIGHT)

    ball.velocity[:x] = -ball.velocity[:x]
    ball.velocity[:y] = -ball.velocity[:y]
  end

  def bullet_collision
    return if @bullets.empty?

    @bullets.each do |bullet|
      @bricks.each do |brick|
        next unless bullet.collides_with?(brick.position, Brick::BRICK_WIDTH, Brick::BRICK_HEIGHT)

        @bullets.delete(bullet)
        cull(brick)
      end
    end
  end

  def update_bullets
    return if @bullets.empty?

    @bullets.each do |bullet|
      bullet.move
      next unless bullet.position[:y].negative?

      if @bullet_count >= 3 && !@paddle.gun
        reset_bullets
      else
        @bullets.delete(bullet)
      end
    end
  end

  def update_bricks
    @bricks.each do |brick|
      next unless brick.capsule.visible

      if @paddle.collides_with?(brick.capsule.position, Capsule::CAPSULE_WIDTH, Capsule::CAPSULE_HEIGHT)
        @bkgnd_timer = Gosu.milliseconds
        brick.capsule.visible = false
        collect_gift(brick.capsule.type)
        @bricks.delete brick
      elsif brick.capsule.position[:y] > Settings::GAME_HEIGHT
        @bricks.delete brick
      end

      brick.capsule.move
    end
  end

  def cull(brick)
    @score += brick.value
    brick.destroy
    @bricks.delete(brick) if brick.capsule.type == :empty
  end

  def draw_score_board
    @font.draw('Level: ' + @level.to_s, 665, 20, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw('Lives: ' + @lives.to_s, 665, 80, 0, 1, 1, Gosu::Color::WHITE)
    @font.draw('Bricks: ' + @bricks.size.to_s, 665, 120, 0, 1, 1, Gosu::Color::WHITE)
    @font.draw('Score: ' + @score.to_s, 665, 160, 0, 1, 1, Gosu::Color::WHITE)
  end

  def draw_info
    if @game_state == State::GAME_OVER
      @large_font.draw('Game Over', 50, 160, 0, 1, 1, Gosu::Color::WHITE)
      @font.draw("Press 'Y' to start again or 'ESC' to quit", 110, 280, 0, 1, 1, Gosu::Color::WHITE)
    elsif @game_state == State::WON
      @large_font.draw('You won', 70, 160, 0, 1, 1, Gosu::Color::WHITE)
      @font.draw("Press 'Y' to play next level or 'ESC' to quit", 80, 280, 0, 1, 1, Gosu::Color::WHITE)
    end
  end

  def button_up(id)
    if id == Gosu::KB_SPACE
      if @game_state == State::BALL_IN_PADDLE
        @game_state = State::PLAYING
        @paddle_state = State::PLAYING
        @balls.each do |ball|
          ball.state = State::PLAYING
          ball.lift_off
        end
      end

      if @game_state == State::PLAYING && @paddle.gun && @bullets.empty?
        @bullets << Bullet.new(position: { x: @paddle.position[:x], y: @paddle.position[:y] })
        @bullets << Bullet.new(position: { x: @paddle.position[:x] + @paddle.width - 5, y: @paddle.position[:y] })
        @bullets.each(&:fire)
        @bullet_count += 1
      end
    end

    if id == Gosu::KB_Y
      if @game_state == State::GAME_OVER
        restart_game
      elsif @game_state == State::WON
        reset_bullets
        background_settings
        @level += 1
        @game_state = State::BALL_IN_PADDLE
        load_paddle
        load_balls
        level = 'level_' + @level.to_s
        @bricks = LevelManager.method(level).call
      end
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end

  def button_pressed
    if Gosu.button_down?(Gosu::KB_LEFT)
      @paddle.move_left
      @balls.each do |ball|
        ball.move_left(centre_x: (@paddle.width - ball.size) / 2)
      end
    elsif Gosu.button_down?(Gosu::KB_RIGHT)
      @paddle.move_right
      @balls.each do |ball|
        ball.move_right(width: @paddle.width, centre_x: (@paddle.width - ball.size) / 2)
      end
    end
  end



  def load_paddle
    @paddle = Paddle.new
  end

  def load_balls
    @balls = []
    @balls << Ball.new(x: @paddle.position[:x] + (@paddle.width / 2) - 8,
                       y: @paddle.position[:y] - @paddle.height)
  end

  def won?
    @bricks.size.zero?
  end

  def restart_game
    initial_game_values
    load_paddle
    load_balls
    reset_bullets
    @paddle.gun = false
    background_settings
    level = 'level_' + @level.to_s
    @bricks = LevelManager.method(level).call
  end

  def reset_bullets
    unless @bullets.empty?
      @bullets.each do |bullet|
        bullet.position[:y] = -100
      end
    end
    @bullets.clear
    @bullet_count = 0
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
    @paddle.reduce
  end

  def large_paddle
    @score += 75
    @paddle.enlarge
  end

  def extra_life
    @score += 75
    @lives += 1 if @lives < 5
  end

  def slow_ball
    @score += 75
    @balls.each do |ball|
      ball.velocity[:x].positive? ? ball.velocity[:x] = SLOW_BALL : ball.velocity[:x] = -SLOW_BALL
      ball.velocity[:y].positive? ? ball.velocity[:y] = SLOW_BALL : ball.velocity[:y] = -SLOW_BALL
    end
  end

  def fast_ball
    @score += 75
    @balls.each do |ball|
      ball.velocity[:x].positive? ? ball.velocity[:x] = FAST_BALL : ball.velocity[:x] = -FAST_BALL
      ball.velocity[:y].positive? ? ball.velocity[:y] = FAST_BALL : ball.velocity[:y] = -FAST_BALL
    end
  end

  def multi
    @score += 75
    velocity = @balls.first.velocity
    position = @balls.first.position
    speed = @balls.first.speed

    new_ball(position, { x: velocity[:x], y: -velocity[:y] }, speed)
    new_ball(position, { x: -velocity[:x], y: velocity[:y] }, speed)
    new_ball(position, { x: -velocity[:x], y: -velocity[:y] }, speed)
  end

  def new_ball(position, velocity, speed)
    ball = Ball.new(x: position[:x], y: position[:y])
    ball.velocity = velocity
    ball.speed = speed
    ball.state = State::PLAYING
    @balls << ball
  end

  def wrap
    @score += 75
    @paddle.action = Paddle::WRAP_ACTION
  end

  def flip
    @score += 75
    @paddle.action = Paddle::FLIP_ACTION
  end

  def gun
    @score += 75
    @paddle.gun = true
  end
end

Game.new.show
