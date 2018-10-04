class Brick
  attr_reader :visible, :value, :position

  def initialize(colour:, value:, position:)
    @visible = true
    @value = value
    @position = position
  end

  def destroy
    @visible = false
    @position = [-1,-1]
  end

  def destroyed_score
    @visible ? 0 : @value
  end
end
