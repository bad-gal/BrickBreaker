require 'bricks'

RSpec.describe Bricks do

  describe '.initialize' do
    context 'when there is a single brick type' do
      let(:bricks) { Bricks.new({size: 10, file: 'image.png', value: 300}) }
      it 'creates an array' do
        expect(bricks.pile).to be_a(Array)
      end
      it 'holds 10 Brick elements' do
        expect(bricks.pile.size).to eq(10)
      end
    end

    context 'when there are multiple brick types' do
      let(:bricks) do
        Bricks.new(
          { size: 5, file: 'image.png', value: 100 },
          { size: 15, file: 'image.png', value: 400 })
      end
      it 'creates an array' do
        expect(bricks.pile).to be_a(Array)
      end
      it 'holds 20 Brick elements' do
        expect(bricks.pile.size).to eq(20)
      end
    end
  end
end
