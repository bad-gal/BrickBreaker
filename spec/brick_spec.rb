require 'image'
require 'capsule'
require 'brick'

RSpec.describe Brick do
  let(:brick) { Brick.new(style: Brick::RED_BRICK, x: 100, y: 100) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(brick).to be_truthy
    end
  end

  describe '.damage' do
    context 'single hit brick' do
      before do
        brick.damage
      end

      it 'reduces hit value to zero' do
        expect(brick.hits).to eq(0)
      end
    end

    context 'multiple hit brick' do
      let(:multi_brick) { Brick.new(style: Brick::BLUE_BRICK, x: 100, y: 100) }
      before do
        # multi_brick.damage
      end

      xit 'reduces hit value to 2' do
        expect(multi_brick.hits).to eq(2)
      end
    end
  end

  describe '.destroy' do

    before do
      brick.destroy
    end

    it 'sets the visible attribute to false' do
      expect(brick.visible).to eq(false)
    end
  end

  describe '.destroyed_score' do

    context 'when brick has been destroyed' do
      before do
        brick.destroy
      end

      it 'returns the score for destroying the brick' do
        expect(brick.destroyed_score).to eq(10)
      end
    end

    context 'when brick has not been destroyed' do
      it 'returns zero' do
        expect(brick.destroyed_score).to eq(0)
      end
    end
  end
end
