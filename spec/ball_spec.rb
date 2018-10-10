require 'image'
require 'ball'

RSpec.describe Ball do
  let(:ball) { Ball.new(file: 'image.png', position: [350, 400]) }

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

  describe '.lift_off' do
    context 'ball vertical position is more than 0' do
      it 'moves the ball upwards' do
        ball.lift_off
        expect(ball.velocity).to eq([0, -Settings::PADDLE_MOVE])
      end
    end
  end

  describe '.bounce_off' do
    context 'when ball collides with the boundary' do
      context 'at the top of the screen' do
        before do
          ball.position[1] = 0
          ball.velocity[1] = -Settings::PADDLE_MOVE
        end
        it 'changes its velocity' do
          ball.bounce_off
          expect(ball.velocity[1]).to eq(Settings::PADDLE_MOVE)
        end
      end
      context 'at the left of the screen' do
        before do
          ball.position[0] = 0
          ball.velocity[0] = -Settings::PADDLE_MOVE
        end
        it 'changes its velocity' do
          ball.bounce_off
          expect(ball.velocity[0]).to eq(Settings::PADDLE_MOVE)
        end
      end
      context 'at the right of the screen' do
        before do
          ball.position[0] = 635
          ball.velocity[0] = Settings::PADDLE_MOVE
        end
        it 'changes its velocity' do
          ball.bounce_off
          expect(ball.velocity[0]).to eq(-Settings::PADDLE_MOVE)
        end
      end
    end
  end

  describe '.lost' do
    context 'when ball has not been caught by paddle' do
      before do
        ball.position = [56, 490]
      end
      it 'returns true that ball is lost' do
        expect(ball.lost?).to eq(true)
      end
    end
  end
end
