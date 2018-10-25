class Ball
  include Image
  attr_accessor :position, :velocity, :speed, :image, :area, :wrap

  REGULAR_BALL_AREA = 16
  SMALL_BALL_AREA = 8

  def initialize(speed = 4, file:, position:)
    @position = position
    @speed = speed
    @velocity = [0, 0]
    @image = Image.create(file: file)
    @area = REGULAR_BALL_AREA
    @centre_on_paddle = (Paddle::REGULAR_PADDLE[:pixel_size] - @area) / 2
    @wrap = false
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end

  def move_left
    if @wrap
      wrap_left
    else
      return if @position[0] < @centre_on_paddle + Settings::PADDLE_MOVE

      @position[0] -= Settings::PADDLE_MOVE
    end
  end

  def move_right
    if @wrap
      wrap_right
    else
      return if @position[0] > Settings::GAME_WIDTH - Settings::PADDLE_MOVE -
                             (Settings::PADDLE_WIDTH - @centre_on_paddle)

      @position[0] += Settings::PADDLE_MOVE
    end
  end

  def wrap_left
    if @position[0] < @centre_on_paddle + Settings::PADDLE_MOVE
      @position[0] = Settings::GAME_WIDTH - Settings::PADDLE_MOVE -
          (Settings::PADDLE_WIDTH - @centre_on_paddle)
    else
      @position[0] -= Settings::PADDLE_MOVE
    end
  end

  def wrap_right
    if @position[0] > Settings::GAME_WIDTH - Settings::PADDLE_MOVE -
        (Settings::PADDLE_WIDTH - @centre_on_paddle)
      @position[0] = @centre_on_paddle + Settings::PADDLE_MOVE
    else
      @position[0] += Settings::PADDLE_MOVE
    end
  end

  def move
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end

  def lift_off
    @velocity[0] = @speed
    @velocity[1] = -@speed
  end

  def boundary_bounce
    @velocity[1] = -@velocity[1] if @position[1] <= 0
    @velocity[0] = -@velocity[0] if @position[0] <= 0
    @velocity[0] = -@velocity[0] if @position[0] + @area >= Settings::GAME_WIDTH
  end

  def bounce_off
    @velocity[1] = -@velocity[1]
  end

  def reposition_to(y_position, height)
    @position[1] = y_position - (height - 1)
  end

  def lost?
    @position[1] > Settings::GAME_HEIGHT + @area
  end

  def collides_with?(pos, width, height)
    if pos[1] < @position[1]
      @position[0] >= pos[0] && @position[0] <= pos[0] + width &&
        @position[1] >= pos[1] && @position[1] <= pos[1] + height
    else
      @position[0] >= pos[0] && @position[0] <= pos[0] + width &&
        @position[1] >= (pos[1] - height) && @position[1] <= pos[1]
    end
  end

  def change(file, pixel_size)
    @image = Image.create(file: file)
    @area = pixel_size
  end
end
