class Brick
  include Image
  attr_reader :visible, :value, :file, :image
  attr_accessor :position, :capsule

  def initialize(file:, value:, position:, capsule: Capsule::CAPSULES.last)
    @visible = true
    @value = value
    @position = position
    @image = Image.create(file: file)
    @capsule = Capsule.new(type: capsule, position: [0, 0])
  end

  def destroy
    @visible = false
    @position = [-100, -100]
    @capsule.visible = true
    @capsule.velocity[1] = Capsule::MOVE
  end

  def destroyed_score
    @visible ? 0 : @value
  end

  def draw
    Image.draw(image: @image, position: @position, z: 0) if visible
  end
end
