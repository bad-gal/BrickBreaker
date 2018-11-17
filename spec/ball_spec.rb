require 'image'
require 'ball'
require 'capsule'
require 'brick'
require 'settings'
require 'paddle'

RSpec.describe Ball do
  let(:ball) { Ball.new(x: 350, y: 400) }
  let(:ball_speed) { Ball::BASIC_SPEED }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(ball).to be_truthy
    end
  end

  describe '.reset' do
    context 'something' do
      before do
        ball.speed = 7
        ball.velocity = { x: 6, y: -6 }
        ball.state = State::PLAYING
        ball.change(Ball::SMALL_BALL_AREA)
      end

      it "reset's the position value set" do
        ball.reset(pos_x: 50, pos_y: 200)
        expect(ball.position).to eq(x: 50, y: 200)
      end
      it "reset's the speed" do
        ball.reset(pos_x: 50, pos_y: 200)
        expect(ball.speed).to eq(Ball::BASIC_SPEED)
      end
      it "reset's the velocity to zero" do
        ball.reset(pos_x: 50, pos_y: 200)
        expect(ball.velocity).to eq(x: 0, y: 0)
      end
      it "reset's the state to ball_in_paddle" do
        ball.reset(pos_x: 50, pos_y: 200)
        expect(ball.state).to eq(State::BALL_IN_PADDLE)
      end
    end
  end

  describe '.draw' do
    it 'calls draw on the ball' do
      expect(ball).to receive(:draw)
      ball.draw
    end
  end

  describe '.move_left' do
    context 'ball horizontal position is more than 5' do
      it 'moves the ball position left' do
        ball.move_left(centre_x: 5)
        expect(ball.position).to eq(x: 345, y: 400)
      end
    end
    context 'ball horizontal position is less than 5' do
      before do
        ball.position = { x: 0, y: 400 }
        ball.move_left(centre_x: 6)
      end
      it 'does not move the ball to the left' do
        expect(ball.position).to eq(x: 0, y: 400)
      end
    end
  end

  describe '.move_right' do
    context 'ball horizontal position is less than screen boundary' do
      it 'moves the ball position right' do
        ball.move_right(width: 40, centre_x: 6)
        expect(ball.position).to eq(x: 355, y: 400)
      end
    end
    context 'ball horizontal position is more than screen boundary' do
      before do
        ball.position = { x: 640, y: 400 }
        ball.move_right(width: 40, centre_x: 6)
      end
      it 'does not move the ball to the right' do
        expect(ball.position).to eq(x: 640, y: 400)
      end
    end
  end

  describe '.move' do
    let(:old_position) { { x: 350, y: 400 } }
    before do
      ball.velocity = { x: -ball_speed, y: -ball_speed }
      ball.state = State::PLAYING
    end
    it 'moves the ball' do
      expect(ball.position).to eq(old_position)
      ball.move
      expect(ball.position).to_not eq(old_position)
    end
  end

  describe '.lift_off' do
    context 'ball vertical position is more than 0' do
      it 'moves the ball upwards' do
        ball.lift_off
        expect(ball.velocity).to eq(x: ball_speed, y: -ball_speed)
      end
    end
  end

  describe '.boundary_bounce' do
    context 'when ball collides with the boundary' do
      context 'at the top of the screen' do
        before do
          ball.position[:y] = -1
          ball.velocity[:y] = -ball_speed
          ball.state = State::PLAYING
        end
        it 'changes its velocity' do
          ball.boundary_bounce
          expect(ball.velocity[:y]).to eq(ball_speed)
        end
      end
      context 'at the left of the screen' do
        before do
          ball.position[:x] = 0
          ball.velocity[:x] = -ball_speed
          ball.state = State::PLAYING
        end
        it 'changes its velocity' do
          ball.boundary_bounce
          expect(ball.velocity[:x]).to eq(ball_speed)
        end
      end
      context 'at the right of the screen' do
        before do
          ball.position[:x] = 635
          ball.velocity[:x] = ball_speed
          ball.state = State::PLAYING
        end
        it 'changes its velocity' do
          ball.boundary_bounce
          expect(ball.velocity[:x]).to eq(-ball_speed)
        end
      end
    end
  end

  describe '.bounce_off' do
    context 'with vertical direction of travel' do
      let(:direction) { { x: ball_speed, y: ball_speed } }
      before do
        ball.velocity = direction
        ball.bounce_off
      end
      it 'changes direction' do
        expect(ball.velocity).to eq(direction)
      end
    end
  end

  describe '.reposition_to' do
    it 'changes the position of the ball' do
      ball.reposition_to(460, 20)
      expect(ball.position[:y]).to eq(441)
    end
  end

  describe '.lost' do
    context 'when ball has not been caught by paddle' do
      before do
        ball.position = { x: 56, y: 500 }
      end
      it 'returns true that ball is lost' do
        expect(ball.lost?).to eq(true)
      end
    end
  end

  describe '.collides_with?' do
    before do
      ball.position = { x: 130, y: 108 }
      ball.state = State::PLAYING

    end
    context 'when a collision occurs' do
      context 'when object is above the ball' do
        let(:brick) { Brick.new(style: Brick::RED_BRICK, x: 100, y: 100) }
        it 'returns true' do
          expect(ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)).to eq(true)
        end
      end
      context 'when object is below the ball' do
        let(:brick) { Brick.new(style: Brick::RED_BRICK, x: 100, y: 400) }
        before do
          ball.position = { x: 130, y: 395 }
        end
        it 'returns true' do
          expect(ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)).to eq(true)
        end
      end
    end
    context 'when there is no collision' do
      let(:brick) { Brick.new(style: Brick::RED_BRICK, x: 300, y: 300) }
      it 'returns fails' do
        expect(ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)).to eq(false )
      end
    end
  end

  describe '.change' do
    context 'when changing image' do
      before do
        ball.change(Ball::SMALL_BALL_AREA)
      end
      it 'changes to a small ball' do
        expect(ball.size).to eq(8)
      end
    end
  end

  describe '.change_velocity_x' do
    let(:paddle) { Paddle.new }

    before do
      paddle.position = { x: 100, y: 200 }
    end

    context 'when ball collides at <= 14% of paddle width' do
      before do
        ball.position = { x: 106, y: 200 }
      end
      it "changes ball's x velocity to -4" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(-4)
      end
    end

    context 'when ball collides at between 15% and 24% of paddle width' do
      before do
        ball.position = { x: 118, y: 200 }
      end
      it "changes ball's x velocity to -3" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(-3)
      end
    end

    context 'when ball collides at between 25% and 36% of paddle width ' do
      before do
        ball.position = { x: 128, y: 200 }
      end
      it "changes ball's x velocity to -2" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(-2)
      end
    end

    context 'when ball collides at between 37% and 48% of paddle width' do
      before do
        ball.position = { x: 136, y: 200 }
      end
      it "changes ball's x velocity to -1" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(-1)
      end
    end

    context 'when ball collides at 49% and 60% of paddle width' do
      before do
        ball.position = { x: 148, y: 200 }
      end
      it "changes ball's x velocity to 1" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(1)
      end
    end

    context 'when ball collides at 61% and 72% of paddle width' do
      before do
        ball.position = { x: 155, y: 200 }
      end
      it "changes ball's x velocity to 2" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(2)
      end
    end

    context 'when ball collides at 73% and 84% of paddle width' do
      before do
        ball.position = { x: 163, y: 200 }
      end
      it "changes ball's x velocity to 3" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(3)
      end
    end

    context 'when ball collides at 85 and 100 width of paddle' do
      before do
        ball.position = { x: 172, y: 200 }
      end
      it "changes ball's x velocity to 4" do
        expect(ball.change_velocity_x(paddle.position, paddle.width)).to eq(4)
      end
    end
  end
end
