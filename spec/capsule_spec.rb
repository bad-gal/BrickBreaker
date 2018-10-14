require 'image'
require 'capsule'

RSpec.describe 'Capsule' do
  let(:capsule) { Capsule.new(type: :score_250, position: [310, 210]) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(capsule).to be_truthy
    end
  end

  describe '.collides_with?' do
    let(:paddle_asset) { { file: 'image.png', pixel_size: 90 } }
    let(:paddle) { Paddle.new([300, 200], details: paddle_asset) }
    context 'when a collision occurs' do
      it 'returns true' do
        expect(capsule.collides_with?(paddle.position, paddle.width, paddle.height)).to eq(true)
      end
    end
    context 'when there is no collision' do
      before do
        paddle.position = [100, 100]
      end
      it 'returns fails' do
        expect(capsule.collides_with?(paddle.position, paddle.width, paddle.height)).to eq(false )
      end
    end
  end

  describe '.fall' do
    context 'when capsule is set to fall' do
      before do
        capsule.visible = true
        capsule.velocity[1] = 5
        capsule.fall
      end
      it 'changes the position of the capsule' do
        expect(capsule.position).to eq([310, 215])
      end
    end
  end

  describe '.acquire_filename' do
    context 'determine the capsule filename given its type' do
      it 'returns the filename assets/test' do
        expect(capsule.acquire_filename(:extra_life)).to eq('assets/capsule_extra_life.png')
      end
    end
  end
end
