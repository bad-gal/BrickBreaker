require 'image'
require 'paddle'

RSpec.describe Paddle do
  let(:paddle) { Paddle.new(file: 'image.png', position: [300, 200]) }

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
end