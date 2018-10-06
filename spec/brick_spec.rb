require 'image'
require 'brick'

RSpec.describe Brick do
  let(:brick) { Brick.new(file: 'image.png', value: 300, position: [100,100]) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(brick).to be_truthy
    end
  end

  describe '.destroy' do
    before do
      brick.destroy
    end
    it 'sets the visible attribute to false' do
      expect(brick).to have_attributes(visible: false, position: [-1, -1])
    end
  end

  describe '.destroyed_score' do
    context 'when brick has been destroyed' do
      before do
        brick.destroy
      end
      it 'returns the score for destroying the brick' do
        expect(brick.destroyed_score).to eq(300)
      end
    end
    context 'when brick has not been destroyed' do
      it 'returns zero' do
        expect(brick.destroyed_score).to eq(0)
      end
    end
  end
end
