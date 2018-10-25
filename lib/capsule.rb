require 'byebug'
class Capsule
  include Image
  attr_accessor :position, :velocity, :visible
  attr_reader :width, :height, :image, :type

  MOVE = 3
  CAPSULES = %i[extra_life small_paddle large_paddle fast_ball slow_ball
                score_250 score_100 score_500 multi wrap flip
                laser gun bomb empty].freeze

  def initialize(type:, position:)
    @image = Image.create(file: acquire_filename(type))
    @type = type
    @position = position
    @width = 60
    @height = 16
    @velocity = [0, 0]
    @visible = false
  end

  def collides_with?(pos, width, height)
    return if type == :empty

    @position[0] >= pos[0] && @position[0] <= pos[0] + width &&
      @position[1] >= pos[1] && @position[1] <= pos[1] + height
  end

  def fall
    return if type == :empty

    @position[1] += @velocity[1] if visible
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0) if @visible
  end

  def acquire_filename(type)
    'assets/capsule_' + type.to_s + '.png'
  end
end
