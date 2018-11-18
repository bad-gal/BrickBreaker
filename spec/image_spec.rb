require 'image'
require 'ball'

RSpec.describe Image do
  describe '.create' do
    it 'creates a Gosu Image' do
      expect(Image.create(file: 'assets/background.png')).to be_kind_of(Gosu::Image)
    end
  end

  describe '.draw' do
    let(:ball) { Ball.new(x: 350, y: 400) }

    it 'calls draw on the class' do
      expect(Image).to receive(:draw)
      Image.draw(image: nil, position: { x: 1, y: 1 })
    end
  end
end
