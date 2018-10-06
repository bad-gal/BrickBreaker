class Ball
  include Image
  attr_reader :position, :image

  def initialize(file:, position:)
    @position = position
    @image = Image.create(file: file)
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end
end
