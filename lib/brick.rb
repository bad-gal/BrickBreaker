class Brick
  include Image
  attr_reader :visible, :value, :file, :image
  attr_accessor :position

  def initialize(file:, value:, position:)
    @visible = true
    @value = value
    @position = position
    @image = Image.create(file: file)
  end

  def destroy
    @visible = false
    @position = [-1,-1]
  end

  def destroyed_score
    @visible ? 0 : @value
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0)
  end
end
