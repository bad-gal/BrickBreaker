class Capsule
  include Image
  attr_accessor :image, :type, :position

  CAPSULES = %i[extra_life multi catch small_paddle large_paddle fast_ball
                slow_ball small_ball laser gun bomb wrap flip].freeze

  def initialize(file:, type:, position:)
    @image = Image.create(file: file)
    @type = type
    @position = position
    @area = 24
  end

  def collides_with?(pos, width, height)
    @position[0] >= pos[0] && @position[0] <= pos[0] + width &&
      @position[1] >= pos[1] && @position[1] <= pos[1] + height
  end
end
