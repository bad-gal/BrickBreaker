class Ball
  include Image
  attr_accessor :position, :velocity, :speed, :image, :area

  REGULAR_BALL_AREA = 16
  SMALL_BALL_AREA = 8

  def initialize(speed = 5, file:, position:)
    @position = position
    @velocity = [0, 0]
    @image = Image.create(file: file)
    @area = REGULAR_BALL_AREA
    @centre_on_paddle = (Settings::PADDLE_WIDTH - @area) / 2
    @speed = speed
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end

  def move_left
    return if @position[0] < @centre_on_paddle + Settings::PADDLE_MOVE

    @position[0] -= Settings::PADDLE_MOVE
  end

  def move_right
    return if @position[0] > Settings::SCREEN_WIDTH - Settings::PADDLE_MOVE -
                             (Settings::PADDLE_WIDTH - @centre_on_paddle)

    @position[0] += Settings::PADDLE_MOVE
  end

  def move
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end

  def lift_off
    @velocity[1] = -@speed
    @velocity[0] = @speed
  end

  def boundary_bounce
    @velocity[1] = -@velocity[1] if @position[1] <= 0
    @velocity[0] = -@velocity[0] if @position[0] <= 0
    @velocity[0] = -@velocity[0] if @position[0] + @area >= Settings::SCREEN_WIDTH
  end

  def bounce_off
    @velocity[1] = -@velocity[1]
  end

  def reposition_to(y_position, height)
    @position[1] = y_position - (height - 1)
  end

  def lost?
    @position[1] > Settings::SCREEN_HEIGHT + @area
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
