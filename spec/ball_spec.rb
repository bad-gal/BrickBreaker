require 'image'
require 'ball'

RSpec.describe Ball do
  let(:ball) { Ball.new(file: 'image.png', position: [350, 400]) }
  let(:ball_speed) { 4 }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(ball).to be_truthy
    end
  end

  describe '.move_left' do
    context 'ball horizontal position is more than 5' do
      it 'moves the ball position left' do
        ball.move_left
        expect(ball.position).to eq([345, 400])
      end
    end
    context 'ball horizontal position is less than 5' do
      before do
        ball.position = [0, 400]
        ball.move_left
      end
      it 'does not move the ball to the left' do
        expect(ball.position).to eq([0, 400])
      end
    end
  end

  describe '.move_right' do
    context 'ball horizontal position is less than screen boundary' do
      it 'moves the ball position right' do
        ball.move_right
        expect(ball.position).to eq([355, 400])
      end
    end
    context 'ball horizontal position is more than screen boundary' do
      before do
        ball.position = [640, 400]
        ball.move_right
      end
      it 'does not move the ball to the right' do
        expect(ball.position).to eq([640, 400])
      end
    end
  end

  describe '.move' do
    let(:old_position) { [350, 400] }
    before do
      ball.velocity = [-ball_speed, -ball_speed]
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
        expect(ball.velocity).to eq([ball_speed, -ball_speed])
      end
    end
  end

  describe '.boundary_bounce' do
    context 'when ball collides with the boundary' do
      context 'at the top of the screen' do
        before do
          ball.position[1] = 0
          ball.velocity[1] = -ball_speed
        end
        it 'changes its velocity' do
          ball.boundary_bounce
          expect(ball.velocity[1]).to eq(ball_speed)
        end
      end
      context 'at the left of the screen' do
        before do
          ball.position[0] = 0
          ball.velocity[0] = -ball_speed
        end
        it 'changes its velocity' do
          ball.boundary_bounce
          expect(ball.velocity[0]).to eq(ball_speed)
        end
      end
      context 'at the right of the screen' do
        before do
          ball.position[0] = 635
          ball.velocity[0] = ball_speed
        end
        it 'changes its velocity' do
          ball.boundary_bounce
          expect(ball.velocity[0]).to eq(-ball_speed)
        end
      end
    end
  end

  describe '.bounce_off' do
    context 'with vertical direction of travel' do
      let(:direction) { [ball_speed, ball_speed] }
      before do
        ball.velocity = [ball_speed, -ball_speed]
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
      expect(ball.position[1]).to eq(441)
    end
  end

  describe '.lost' do
    context 'when ball has not been caught by paddle' do
      before do
        ball.position = [56, 500]
      end
      it 'returns true that ball is lost' do
        expect(ball.lost?).to eq(true)
      end
    end
  end

  describe '.collides_with?' do
    before do
      ball.position = [130, 108]
    end
    context 'when a collision occurs' do
      context 'when object is above the ball' do
        let(:brick) { Brick.new(file: 'image.png', value: 300, position: [100, 100]) }
        it 'returns true' do
          expect(ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)).to eq(true)
        end
      end
      context 'when object is below the ball' do
        let(:brick) { Brick.new(file: 'image.png', value: 300, position: [100, 400]) }
        before do
          ball.position = [130, 395]
        end
        it 'returns true' do
          expect(ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)).to eq(true)
        end
      end
    end
    context 'when there is no collision' do
      let(:brick) { Brick.new(file: 'image.png', value: 300, position: [300, 300]) }
      it 'returns fails' do
        expect(ball.collides_with?(brick.position, Settings::BRICK_WIDTH, Settings::BRICK_HEIGHT)).to eq(false )
      end
    end
  end

  describe '.change_size' do
    context 'when changing image' do
      before do
        ball.change('image.png', 6)
      end
      it 'changes to a small ball' do
        expect(ball.area).to eq(6)
      end
    end
  end
end
