class Brick
  include Image
  attr_reader :value, :hits, :type, :image, :visible
  attr_accessor :position, :capsule

  CEMENT_BRICK = { type: :cement, file: 'assets/brick_cement.png', value: 100, hits: 1, breakable: false }.freeze
  BLUE_BRICK = { type: :blue, file: 'assets/brick_blue.png', value: 20, hits: 3, breakable: true }.freeze
  YELLOW_BRICK = { type: :yellow, file: 'assets/brick_yellow.png', value: 20, hits: 2, breakable: true }.freeze
  GREEN_BRICK = { type: :green, file: 'assets/brick_green.png', value: 20,hits: 2, breakable: true }.freeze
  ORANGE_BRICK = { type: :orange, file: 'assets/brick_orange.png', value: 10, hits: 1, breakable: true }.freeze
  PURPLE_BRICK = { type: :purple, file: 'assets/brick_purple.png', value: 10, hits: 1, breakable: true }.freeze
  RED_BRICK = { type: :red, file: 'assets/brick_red.png', value: 10, hits: 1, breakable: true }.freeze
  BRICK_WIDTH = 80
  BRICK_HEIGHT = 27

  def initialize(style:, x:, y:, capsule: Capsule::CAPSULES.last)
    @position = { x: x, y: y }
    @type = style[:type]
    @breakable = style[:breakable]
    @hits = style[:hits]
    @value = style[:value]
    @visible = true
    x_diff = (BRICK_WIDTH - Capsule::CAPSULE_WIDTH) / 2
    @capsule = Capsule.new(type: capsule, x: @position[:x] + x_diff, y: @position[:y])
    @image = Image.create(file: style[:file])
  end

  def draw
    Image.draw(image: @image, position: @position) if visible
  end

  def damage
    return unless @breakable

    @hits -= 1
    return if @hits.zero?

    change_image
  end

  def change_image
    filename = 'assets/brick_' + @type.to_s + '_damage.png'
    @image = Image.create(file: filename)
  end

  def destroy
    @visible = false
    @position[:x] = -100
    @position[:y] = -100
    return if @capsule.type == :empty

    @capsule.visible = true
    @capsule.velocity[:y] = Capsule::MOVE
  end

  def destroyed_score
    @visible ? 0 : @value
  end
end
