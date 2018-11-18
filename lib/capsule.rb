class Capsule
  include Image
  attr_accessor :position, :velocity, :visible, :type, :image

  MOVE = 3
  CAPSULE_WIDTH = 60
  CAPSULE_HEIGHT = 16

  CAPSULES = %i[extra_life small_paddle large_paddle fast_ball slow_ball
                score_250 score_100 score_500 multi wrap flip
                laser gun bomb empty].freeze

  def initialize(type:, x:, y:)
    @image = Image.create(file: acquire_filename(type))
    @type = type
    @position = { x: x, y: y }
    @velocity = { x: 0, y: 0 }
    @visible = false
  end

  def draw
    Image.draw(image: @image, position: @position) if @visible
  end

  def move
    return if @type == :empty

    @position[:y] += @velocity[:y] if @visible
  end

  def acquire_filename(type)
    'assets/capsule_' + type.to_s + '.png'
  end
end
