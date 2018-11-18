class Bullet
  attr_accessor :position, :velocity
  attr_reader :width, :height

  def initialize(position:)
    @image = Image.create(file: 'assets/bullet.png')
    @position = position
    @width = 9
    @height = 20
    @velocity = { x: 0, y: 0 }
  end

  def draw
    Image.draw(image: @image, position: @position)
  end

  def collides_with?(pos, width, height)
    Settings::overlapping?(pos[:x], pos[:x] + width, @position[:x], @position[:x] + @width) &&
      Settings::overlapping?(pos[:y], pos[:y] + height, @position[:y], @position[:y] + @height)
  end

  def move
    @position[:y] += @velocity[:y]
  end

  def fire
    @velocity[:y] = -4
  end
end
