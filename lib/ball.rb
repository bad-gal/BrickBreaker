require_relative 'state'

class Ball
  include Image
  attr_reader :image, :size
  attr_accessor :state, :velocity, :speed, :position

  REGULAR_BALL_AREA = { file: 'assets/ball_regular.png', size: 16 }.freeze
  SMALL_BALL_AREA = { file: 'assets/ball_small.png', size: 8 }.freeze
  BASIC_SPEED = 4

  def initialize(speed = BASIC_SPEED, ball_image = REGULAR_BALL_AREA, x:, y:)
    @position = { x: x, y: y }
    @speed = speed
    @velocity = { x: 0, y: 0 }
    @image = Image.create(file: ball_image[:file])
    @size = ball_image[:size]
    @state = State::BALL_IN_PADDLE
  end

  def reset(pos_x:, pos_y:)
    @position = { x: pos_x, y: pos_y }
    @speed = BASIC_SPEED
    @velocity = { x: 0, y: 0 }
    @image = Image.create(file: REGULAR_BALL_AREA[:file])
    @size = REGULAR_BALL_AREA[:size]
    @state = State::BALL_IN_PADDLE
  end

  def draw
    Image.draw(image: @image, position: @position)
  end

  def move_left(centre_x:)
    return unless @state == State::BALL_IN_PADDLE

    return if @position[:x] < centre_x + Settings::PADDLE_MOVE

    @position[:x] -= Settings::PADDLE_MOVE
  end

  def move_right(width:, centre_x:)
    return unless @state == State::BALL_IN_PADDLE

    return if @position[:x] > Settings::GAME_WIDTH - Settings::PADDLE_MOVE - (width - centre_x)

    @position[:x] += Settings::PADDLE_MOVE
  end

  def move
    return unless state == State::PLAYING

    @position[:x] += @velocity[:x]
    @position[:y] += @velocity[:y]
  end

  def lift_off
    @velocity[:x] = @speed
    @velocity[:y] = -@speed
  end

  def boundary_bounce
    return unless state == State::PLAYING

    if @position[:y].negative?
      @position[:y] = 0
      @velocity[:y] = -@velocity[:y]
    end

    if @position[:x] <= 0
      @position[:x] = 0
      @velocity[:x] = -@velocity[:x]
    end

    if @position[:x] + @size >= Settings::GAME_WIDTH
      @position[:x] = Settings::GAME_WIDTH - @size
      @velocity[:x] = -@velocity[:x]
    end
  end

  def bounce_off
    @velocity[:y] = -@velocity[:y]
  end

  def reposition_to(y_position, height)
    @position[:y] = y_position - (height - 1)
  end

  def lost?
    @position[:y] > Settings::GAME_HEIGHT + @size
  end

  def collides_with?(pos, width, height)
    return false unless state == State::PLAYING

    Settings::overlapping?(pos[:x], pos[:x] + width, (@position[:x] + @velocity[:x]), (@position[:x] + @velocity[:x]) + @size) &&
        Settings::overlapping?(pos[:y], pos[:y] + height, (@position[:y] + @velocity[:y]), (@position[:y] + @velocity[:y]) + @size)
  end

  def change(ball_image)
    @image = Image.create(file: ball_image[:file])
    @size = ball_image[:size]
  end

  def change_velocity_x(pos, width)
    position_on_paddle = @position[:x] - pos[:x]
    percentage = ((position_on_paddle.to_f /  width.to_f) * 100).round

    case percentage
    when 0..14
      @velocity[:x] = -4
    when 15..24
      @velocity[:x] = -3
    when 25..36
      @velocity[:x] = -2
    when 37..48
      @velocity[:x] = -1
    when 49..60
      @velocity[:x] = 1
    when 61..72
      @velocity[:x] = 2
    when 73..84
      @velocity[:x] = 3
    when 85..100
      @velocity[:x] = 4
    end
  end
end
