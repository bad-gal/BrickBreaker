class Ball
  include Image
  attr_accessor :position, :velocity
  attr_reader :image

  def initialize(file:, position:)
    @position = position
    @velocity = [0, 0]
    @image = Image.create(file: file)
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end

  def move_left
    return if @position[0] < Settings::RB_CENTRE_ON_PADDLE + Settings::PADDLE_MOVE

    @position[0] -= Settings::PADDLE_MOVE
  end

  def move_right
    return if @position[0] > Settings::SCREEN_WIDTH - Settings::PADDLE_MOVE -
                             (Settings::PADDLE_WIDTH - Settings::RB_CENTRE_ON_PADDLE)

    @position[0] += Settings::PADDLE_MOVE
  end

  def lift_off
    @velocity[1] = -Settings::PADDLE_MOVE
    @velocity[0] = Settings::PADDLE_MOVE
  end

  def move
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end

  def boundary_bounce
    @velocity[1] = -@velocity[1] if @position[1] <= 0
    @velocity[0] = -@velocity[0] if @position[0] <= 0
    @velocity[0] = -@velocity[0] if @position[0] + Settings::REGULAR_BALL_AREA >= Settings::SCREEN_WIDTH
  end

  def bounce_off
    @velocity[1] = -@velocity[1]
  end

  def lost?
    @position[1] > Settings::SCREEN_HEIGHT + Settings::REGULAR_BALL_AREA
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
end
