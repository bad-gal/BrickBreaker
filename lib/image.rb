require 'gosu'

module Image

  def self.create(file:)
    Gosu::Image.new(file, tileable: true)
  end

  def self.draw(image:, position:)
    image.draw(position[:x], position[:y], 0)
  end
end
