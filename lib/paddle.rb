require_relative 'settings'

class Paddle
  include Image
  attr_accessor :position
  attr_reader :image

  def initialize(file:, position:)
    @position = position
    @image = Image.create(file: file)
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end

  def move_left
    return if @position[0] < Settings::PADDLE_MOVE

    @position[0] -= Settings::PADDLE_MOVE
  end

  def move_right
    return if @position[0] > ((Settings::SCREEN_WIDTH - Settings::PADDLE_MOVE) -
        Settings::PADDLE_WIDTH)

    @position[0] += Settings::PADDLE_MOVE
  end
end
