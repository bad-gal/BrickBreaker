module Image

  def self.create(file:)
    Gosu::Image.new(file, tileable: true)
  end

  def self.draw(image:, position:, z:)
    image.draw(position.first, position.last, z)
  end
end
