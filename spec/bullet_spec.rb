require 'image'
require 'bullet'
require 'brick'
require 'capsule'
require 'settings'

RSpec.describe Bullet do
  let(:bullet) { Bullet.new(position: { x: 100, y: 200 }) }

  describe '.initialise' do
    it 'is valid with the correct parameters' do
      expect(bullet).to be_truthy
    end
  end

  describe '.draw' do
    it 'calls draw on the ball' do
      expect(bullet).to receive(:draw)
      bullet.draw
    end
  end

  describe '.collides_with?' do
    let(:brick) { Brick.new(style: Brick::RED_BRICK, x: 100, y: 199) }

    context 'bullet hits brick' do
      it 'returns true' do
        expect(bullet.collides_with?(brick.position, Brick::BRICK_WIDTH, Brick::BRICK_HEIGHT)).to eq(true)
      end
    end

    context 'bullet does not hit brick' do
      before do
        bullet.position = { x: 500, y: 200 }
      end

      it 'returns false' do
        expect(bullet.collides_with?(brick.position, Brick::BRICK_WIDTH, Brick::BRICK_HEIGHT)).to eq(false)
      end
    end
  end

  describe '.move' do
    before do
      bullet.velocity[:y] = -3
      bullet.move
    end
    it 'moves the bullet' do
      expect(bullet.position).to eq(x: 100, y: 197)
    end
  end

  describe '.fire' do
    before do
      bullet.fire
    end
    it 'fires the bullet' do
      expect(bullet.velocity).to eq(x: 0, y:-4)
    end
  end
end
