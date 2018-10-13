require 'image'
require 'paddle'

RSpec.describe Paddle do
  let(:paddle_asset) { { file: 'image.png', pixel_size: 90 } }
  let(:paddle) { Paddle.new([300, 200], details: paddle_asset) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(paddle).to be_truthy
    end
  end

  describe '.move_left' do
    context 'paddle horizontal position is more than 5' do
      it 'moves the paddle position left' do
        paddle.move_left
        expect(paddle.position).to eq([295, 200])
      end
    end
    context 'paddle horizontal position is less than 5' do
      before do
        paddle.position = [0, 200]
        paddle.move_left
      end
      it 'does not move the paddle to the left' do
        expect(paddle.position).to eq([0, 200])
      end
    end
  end

  describe '.move_right' do
    context 'paddle horizontal position is less than screen boundary' do
      it 'moves the paddle position right' do
        paddle.move_right
        expect(paddle.position).to eq([305, 200])
      end
    end
    context 'paddle horizontal position is more than screen boundary' do
      before do
        paddle.position = [640, 200]
        paddle.move_right
      end
      it 'does not move the paddle to the right' do
        expect(paddle.position).to eq([640, 200])
      end
    end
  end

  describe '.change' do
    context 'when paddle size changed to small' do
      let(:small) { { file: 'image.png', pixel_size: 60 } }

      it 'is successfully changed' do
        paddle.change(details: small)
        expect(paddle.width).to eq(60)
      end
    end
    context 'when paddle size changed to large' do
      let(:large) { { file: 'image.png', pixel_size: 120 } }

      it 'is successfully changed' do
        paddle.change(details: large)
        expect(paddle.width).to eq(120)
      end
    end
  end
end