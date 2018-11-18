module LevelManager

  BRICKS_PER_ROW = 8

  def self.level_0
    bricks = []
    x = Brick::BRICK_WIDTH * 2
    y = Brick::BRICK_HEIGHT * 3

    1.upto(12) do
      bricks << Brick.new(style: Brick::CEMENT_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if x == Brick::BRICK_WIDTH * 6
        x = Brick::BRICK_WIDTH * 2
        y += Brick::BRICK_HEIGHT
      end
    end
    create_capsules(bricks, [{ type: :slow_ball, amt: 1 }, { type: :flip, amt: 1 }, { type: :score_100, amt: 2 }])
    bricks
  end

  def self.level_1
    bricks = []
    x = 0
    y = 0
    1.upto(BRICKS_PER_ROW * 2) do
      bricks << Brick.new(style: Brick::RED_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if x == Settings::GAME_WIDTH
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end

    1.upto(BRICKS_PER_ROW * 2) do
      bricks << Brick.new(style: Brick::ORANGE_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if x == Settings::GAME_WIDTH
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end
    create_capsules(bricks, [{ type: :large_paddle, amt: 1 }, { type: :fast_ball, amt: 1 }])
    bricks
  end

  def self.level_2
    bricks = []
    x = 0
    y = (Brick::BRICK_HEIGHT * 2)

    1.upto(BRICKS_PER_ROW * 2) do
      bricks << Brick.new(style: Brick::PURPLE_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if x == Settings::GAME_WIDTH
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end

    y += Brick::BRICK_HEIGHT
    1.upto(BRICKS_PER_ROW * 3) do
      bricks << Brick.new(style: Brick::RED_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if x == Settings::GAME_WIDTH
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end

    1.upto(BRICKS_PER_ROW) do
      bricks << Brick.new(style: Brick::GREEN_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
    end

    create_capsules(bricks, [{ type: :extra_life, amt: 1 }, { type: :gun, amt: 1 }])
    bricks
  end

  def self.level_3
    bricks = []
    x = Brick::BRICK_WIDTH * 3
    y = Brick::BRICK_HEIGHT * 2

    1.upto(4) do |i|
      bricks << Brick.new(style: Brick::YELLOW_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
      if i == 2
        x = Brick::BRICK_WIDTH * 3
        y = Brick::BRICK_HEIGHT * 3
      end
    end

    x = Brick::BRICK_WIDTH * 2
    y = Brick::BRICK_HEIGHT * 4
    1.upto(8) do |i|
      bricks << Brick.new(style: Brick::GREEN_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
      if i == 4
        x = Brick::BRICK_WIDTH * 2
        y = Brick::BRICK_HEIGHT * 5
      end
    end

    x = Brick::BRICK_WIDTH * 1
    y = Brick::BRICK_HEIGHT * 6
    1.upto(12) do |i|
      bricks << Brick.new(style: Brick::BLUE_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
      if i == 6
        x = Brick::BRICK_WIDTH * 1
        y = Brick::BRICK_HEIGHT * 7
      end
    end

    x = Brick::BRICK_WIDTH * 2
    y = Brick::BRICK_HEIGHT * 8
    1.upto(8) do |i|
      bricks << Brick.new(style: Brick::GREEN_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
      if i == 4
        x = Brick::BRICK_WIDTH * 2
        y = Brick::BRICK_HEIGHT * 9
      end
    end

    x = Brick::BRICK_WIDTH * 3
    y = Brick::BRICK_HEIGHT * 10
    1.upto(4) do |i|
      bricks << Brick.new(style: Brick::YELLOW_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
      if i == 2
        x = Brick::BRICK_WIDTH * 3
        y = Brick::BRICK_HEIGHT * 11
      end
    end
    create_capsules(bricks, [{ type: :extra_life, amt: 1 }, { type: :score_500, amt: 1 }, { type: :small_paddle, amt: 1 }])
    bricks
  end

  def self.level_4
    bricks = []
    x = 0

    1.upto(4) do
      y = 0
      1.upto(4) do
        bricks << Brick.new(style: Brick::BLUE_BRICK, x: x, y: y)
        y += Brick::BRICK_HEIGHT * 2
      end

      x += Brick::BRICK_WIDTH * 2
    end

    x = Brick::BRICK_WIDTH
    1.upto(4) do
      y = Brick::BRICK_HEIGHT
      1.upto(4) do
        bricks << Brick.new(style: Brick::YELLOW_BRICK, x: x, y: y)
        y += Brick::BRICK_HEIGHT * 2
      end

      x += Brick::BRICK_WIDTH * 2
    end

    create_capsules(bricks,
                    [{ type: :score_250, amt: 1 },
                     { type: :multi, amt: 1 },
                     { type: :fast_ball, amt: 1 }])
    bricks
  end

  def self.level_5
    bricks = []
    x = 0
    y = 0
    1.upto(BRICKS_PER_ROW) do
      bricks << Brick.new(style: Brick::BLUE_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
    end

    x = 0
    y = Brick::BRICK_HEIGHT
    1.upto(12) do |i|
      bricks << Brick.new(style: Brick::GREEN_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if (i == 3) || (i == 9)
        x += Brick::BRICK_WIDTH * 2
      end

      if i == 6
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end

    x = 0
    y = Brick::BRICK_HEIGHT * 3
    1.upto(8) do |i|
      bricks << Brick.new(style: Brick::YELLOW_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if (i == 2) || (i == 6)
        x += Brick::BRICK_WIDTH * 4
      end

      if i == 4
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end

    x = 0
    y = Brick::BRICK_HEIGHT * 5
    1.upto(4) do |i|
      bricks << Brick.new(style: Brick::PURPLE_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH

      if (i == 1) || (i == 3)
        x += Brick::BRICK_WIDTH * 6
      end

      if i == 2
        x = 0
        y += Brick::BRICK_HEIGHT
      end
    end

    create_capsules(bricks,
                    [{ type: :large_paddle, amt: 1 },
                     { type: :wrap, amt: 1 },
                     { type: :gun, amt: 1 }])

    x = Brick::BRICK_WIDTH * 2
    y += Brick::BRICK_HEIGHT * 2
    1.upto(4) do
      bricks << Brick.new(style: Brick::CEMENT_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
    end

    bricks
  end

  def self.level_6
    bricks = []
    x = 0
    y = 0
    1.upto(10) do |i|
      bricks << Brick.new(style: Brick::YELLOW_BRICK, x: x, y: y)
      y += Brick::BRICK_HEIGHT
    end
    bricks << Brick.new(style: Brick::CEMENT_BRICK, x: x, y: y)

    x = Brick::BRICK_WIDTH * 2
    y = 0
    1.upto(10) do |i|
      bricks << Brick.new(style: Brick::GREEN_BRICK, x: x, y: y)
      y += Brick::BRICK_HEIGHT
    end
    bricks << Brick.new(style: Brick::CEMENT_BRICK, x: x, y: y)

    x = Brick::BRICK_WIDTH * 5
    y = 0
    1.upto(10) do |i|
      bricks << Brick.new(style: Brick::GREEN_BRICK, x: x, y: y)
      y += Brick::BRICK_HEIGHT
    end
    bricks << Brick.new(style: Brick::CEMENT_BRICK, x: x, y: y)

    x = Brick::BRICK_WIDTH * 7
    y = 0
    1.upto(10) do |i|
      bricks << Brick.new(style: Brick::YELLOW_BRICK, x: x, y: y)
      y += Brick::BRICK_HEIGHT
    end
    bricks << Brick.new(style: Brick::CEMENT_BRICK, x: x, y: y)

    x = Brick::BRICK_WIDTH * 2
    y = Brick::BRICK_HEIGHT * 12
    1.upto(4) do |i|
      bricks << Brick.new(style: Brick::BLUE_BRICK, x: x, y: y)
      x += Brick::BRICK_WIDTH
    end

    create_capsules(bricks,
                    [{ type: :score_100, amt: 1 },
                     { type: :multi, amt: 1 },
                     { type: :flip, amt: 1 }])

    create_capsule_at_position(bricks[46], :gun)
    bricks
  end

  def self.create_capsules(bricks, capsules)
    size = capsules.sum{ |cap| cap[:amt] }
    capsule_bricks = bricks.sample(size)

    i = 0
    capsules.each do |capsule|
      length = capsule[:amt]
      1.upto(length) do
        # x_diff = (Brick::BRICK_WIDTH - Capsule::CAPSULE_WIDTH) / 2
        capsule_bricks[i].capsule = Capsule.new(type: capsule[:type],
                                                x: capsule_bricks[i].position[:x] + brick_pos_x,
                                                y: capsule_bricks[i].position[:y] )
        i += 1
      end
    end
  end

  def self.create_capsule_at_position(brick, type)
    brick.capsule = Capsule.new(type: type,
                                x: brick.position[:x] + brick_pos_x,
                                y: brick.position[:y])
  end

  def self.brick_pos_x
    (Brick::BRICK_WIDTH - Capsule::CAPSULE_WIDTH) / 2
  end
end
