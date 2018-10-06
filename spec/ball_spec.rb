require 'image'
require 'ball'

RSpec.describe Ball do
  let(:ball) { Ball.new(file: 'image.png', position: [100, 100]) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(ball).to be_truthy
    end
  end
end