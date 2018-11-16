require 'image'
require 'paddle'
require 'capsule'

RSpec.describe Paddle do
  let(:paddle_asset) { { file: 'image.png', pixel_size: 90 } }
  let(:paddle) { Paddle.new }

  describe '.reset' do
    it 'sets paddle position' do
      expect(paddle.position).to eq(x: 280, y: 464)
    end
    it 'sets image width' do
      expect(paddle.width).to eq(Paddle::REGULAR_PADDLE[:width])
    end
    it 'sets image height' do
      expect(paddle.height).to eq(Paddle::HEIGHT)
    end
    it 'sets paddle state to ball_in_paddle' do
      expect(paddle.state).to eq(State::BALL_IN_PADDLE)
    end
    it 'sets paddle action to normal' do
      expect(paddle.action).to eq(Paddle::NORMAL_ACTION)
    end
    it 'sets gun to false' do
      expect(paddle.gun).to eq(false)
    end
  end

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(paddle).to be_truthy
    end
  end

  describe '.move_left' do
    context 'paddle horizontal position is more than 5' do
      it 'moves the paddle position left' do
        paddle.move_left
        expect(paddle.position).to eq(x: 275, y: 464)
      end
    end
    context 'paddle horizontal position is less than 5' do
      before do
        paddle.position = { x: 0, y: 200 }
        paddle.move_left
      end
      it 'does not move the paddle to the left' do
        expect(paddle.position).to eq(x: 0, y: 200)
      end
    end
  end

  describe '.move_right' do
    context 'paddle horizontal position is less than screen boundary' do
      it 'moves the paddle position right' do
        paddle.move_right
        expect(paddle.position).to eq(x: 285, y: 464)
      end
    end
    context 'paddle horizontal position is more than screen boundary' do
      before do
        paddle.position = { x: 640, y: 200 }
        paddle.move_right
      end
      it 'does not move the paddle to the right' do
        expect(paddle.position).to eq(x: 640, y: 200)
      end
    end
  end

  describe '.wrap_left' do
    context 'when paddle is at the far left of the screen' do
      before do
        paddle.position[:x] = 3
        paddle.state = State::PLAYING
        paddle.wrap_left
      end

      it 'wraps the paddle to the far right of the screen' do
        expect(paddle.position[:x]).to eq(Settings::GAME_WIDTH - Settings::PADDLE_MOVE  - paddle.width)
      end
    end

    context 'when paddle is not near the far left of the screen' do
      before do
        paddle.state = State::PLAYING
        paddle.wrap_left
      end
      it 'moves the paddle to the left' do
        expect(paddle.position[:x]).to eq(275)
      end
    end
  end

  describe '.wrap_right' do
    context 'when paddle is at the far right of the screen' do
      before do
        paddle.position[:x] = Settings::GAME_WIDTH - 3
        paddle.state = State::PLAYING
        paddle.wrap_right
      end

      it 'wraps the paddle to the far left of the screen' do
        expect(paddle.position[:x]).to eq(Settings::PADDLE_MOVE)
      end
    end

    context 'when paddle is not near the far right of the screen' do
      before do
        paddle.state = State::PLAYING
        paddle.wrap_right
      end
      it 'moves the paddle to the right' do
        expect(paddle.position[:x]).to eq(285)
      end
    end
  end

  describe '.flip_left' do
    context 'paddle horizontal position is less than screen boundary' do
      it 'moves the paddle position right' do
        paddle.flip_left
        expect(paddle.position).to eq(x: 285, y: 464)
      end
    end
    context 'paddle horizontal position is more than screen boundary' do
      before do
        paddle.position = { x: 640, y: 200 }
        paddle.flip_left
      end
      it 'does not move the paddle to the right' do
        expect(paddle.position).to eq(x: 640, y: 200)
      end
    end
  end

  describe '.flip_right' do
    context 'paddle horizontal position is more than 5' do
      it 'moves the paddle position left' do
        paddle.flip_right
        expect(paddle.position).to eq(x: 275, y: 464)
      end
    end
    context 'paddle horizontal position is less than 5' do
      before do
        paddle.position = { x: 0, y: 200 }
        paddle.flip_right
      end
      it 'does not move the paddle to the left' do
        expect(paddle.position).to eq(x: 0, y: 200)
      end
    end
  end

  describe '.reduce' do
    context 'when paddle size is reduced' do
      before do
        paddle.reduce
      end

      it 'makes the width of the paddle smaller' do
        expect(paddle.width).to eq(Paddle::SMALL_PADDLE[:width])
      end
    end
  end

  describe '.enlarge' do
    context 'when paddle size is increased' do
      before do
        paddle.enlarge
      end

      it 'makes the width of the paddle larger' do
        expect(paddle.width).to eq(Paddle::LARGE_PADDLE[:width])
      end
    end
  end

  describe '.collides_with?' do
    let(:capsule) { Capsule.new(type: :score_250, x: 310, y: 467) }

    context 'when a collision does not occur' do
      before do
        paddle.position[:x] = 29
      end

      it 'returns false' do
        expect(paddle.collides_with?(capsule.position, Capsule::CAPSULE_WIDTH, Capsule::CAPSULE_HEIGHT)).to eq(false)
      end
    end

    context 'when a collision occurs' do
      before do
        paddle.reset
      end

      it 'returns true' do
        expect(paddle.collides_with?(capsule.position, Capsule::CAPSULE_WIDTH, Capsule::CAPSULE_HEIGHT)).to eq(true)
      end
    end
  end
end