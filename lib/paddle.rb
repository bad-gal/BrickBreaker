require_relative 'state'
require_relative 'settings'

class Paddle
  include Image
  attr_accessor :width, :height, :position, :state, :gun, :action
  attr_reader :image

  SMALL_PADDLE = { file: 'assets/paddle_small.png', width: 61 }.freeze
  REGULAR_PADDLE = { file: 'assets/paddle_simple.png', width: 80 }.freeze
  LARGE_PADDLE = { file: 'assets/paddle_large.png', width: 100 }.freeze
  HEIGHT = 16
  NORMAL_ACTION = :normal
  WRAP_ACTION = :wrap
  FLIP_ACTION = :flip

  def initialize
    reset
  end

  def reset
    @image = Image.create(file: REGULAR_PADDLE[:file])
    @width = REGULAR_PADDLE[:width]
    @height = HEIGHT
    @state = State::BALL_IN_PADDLE
    @action = NORMAL_ACTION
    x = (Settings::GAME_WIDTH / 2) - (@width / 2)
    y =  Settings::GAME_HEIGHT - @height
    @position = { x: x, y: y }
    @gun = false
  end

  def draw
    Image.draw(image: @image, position: @position)
  end

  def move_left
    method(@action.to_s + '_left').call
  end

  def move_right
    method(@action.to_s + '_right').call
  end

  def normal_left
    return if @position[:x] < Settings::PADDLE_MOVE

    @position[:x] -= Settings::PADDLE_MOVE
  end

  def normal_right
    return if @position[:x] > ((Settings::GAME_WIDTH - Settings::PADDLE_MOVE) - @width)

    @position[:x] += Settings::PADDLE_MOVE
  end

  def wrap_left
    if @position[:x] < Settings::PADDLE_MOVE
      @position[:x] = (Settings::GAME_WIDTH - Settings::PADDLE_MOVE) - @width
    else
      @position[:x] -= Settings::PADDLE_MOVE
    end
  end

  def wrap_right
    if @position[:x] > ((Settings::GAME_WIDTH - Settings::PADDLE_MOVE) - @width)
      @position[:x] = Settings::PADDLE_MOVE
    else
      @position[:x] += Settings::PADDLE_MOVE
    end
  end

  def flip_left
    normal_right
  end

  def flip_right
    normal_left
  end

  def reduce
    @image = Image.create(file: SMALL_PADDLE[:file])
    @width = SMALL_PADDLE[:width]
  end

  def enlarge
    @image = Image.create(file: LARGE_PADDLE[:file])
    @width = LARGE_PADDLE[:width]
  end

  def collides_with?(pos, width, height)
    Settings.overlapping?(pos[:x], pos[:x] + width, @position[:x], @position[:x] + @width) &&
      Settings.overlapping?(pos[:y], pos[:y] + height, @position[:y], @position[:y] + @height)
  end
end
