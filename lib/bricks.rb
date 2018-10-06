class Bricks < Brick
  attr_reader :pile

  def initialize(*objects)
    @pile = []
    objects.each do |obj|
      size = obj[:size]
      1.upto(size) do
        @pile << Brick.new(file: obj[:file], value: obj[:value], position: [0, 0])
      end
    end
  end
end
