require_relative 'settings'

class Paddle
  include Image
  attr_accessor :position, :width, :height
  attr_reader :image

  SMALL_PADDLE = { file: 'assets/paddle_small.png', pixel_size: 61 }.freeze
  REGULAR_PADDLE = { file: 'assets/paddle_simple.png', pixel_size: 80 }.freeze
  LONG_PADDLE = { file: 'assets/paddle_large.png', pixel_size: 100 }.freeze

  def initialize(position = [0, 0], details:)
    @position = position
    @image = Image.create(file: details[:file])
    @width = details[:pixel_size]
    @height = 16
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end

  def move_left
    return if @position[0] < Settings::PADDLE_MOVE

    @position[0] -= Settings::PADDLE_MOVE
  end

  def move_right
    return if @position[0] > ((Settings::GAME_WIDTH - Settings::PADDLE_MOVE) -
        Settings::PADDLE_WIDTH)

    @position[0] += Settings::PADDLE_MOVE
  end

  def change(details:)
    @image = Image.create(file: details[:file])
    @width = details[:pixel_size]
  end
end
