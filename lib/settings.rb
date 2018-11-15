module Settings
  GAME_WIDTH = 640
  GAME_HEIGHT = 480
  SCREEN_WIDTH = 800
  BRICK_WIDTH = 80
  BRICK_HEIGHT = 16
  BRICKS_PER_ROW = 640 / 80
  PADDLE_MOVE = 5
  PADDLE_WIDTH = 80
  PADDLE_HEIGHT = 16

  def self.overlapping?(left1, right1, left2, right2)
    left2 <= right1 && left1 <= right2
  end
end
