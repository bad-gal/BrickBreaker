require 'image'
require 'capsule'

RSpec.describe 'Capsule' do
  let(:capsule) { Capsule.new(type: :score_250, x: 310, y: 210) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(capsule).to be_truthy
    end
  end

  describe '.move' do
    context 'when capsule is set to fall' do
      before do
        capsule.visible = true
        capsule.velocity[:y] = 5
        capsule.move
      end
      it 'changes the position of the capsule' do
        expect(capsule.position).to eq(x: 310, y: 215)
      end
    end

    context 'when capsule type is empty' do
      before do
        capsule.type = :empty
        capsule.velocity[:y] = 5
        capsule.move
      end
      it 'does not move the capsule' do
        expect(capsule.position).to eq(x: 310, y: 210)
      end
    end
  end

  describe '.draw' do
    it 'calls draw on the ball' do
      expect(capsule).to receive(:draw)
      capsule.draw
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
