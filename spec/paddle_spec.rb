require 'image'
require 'paddle'

RSpec.describe Paddle do
  let(:paddle) { Paddle.new(file: 'image.png', position: [300, 200]) }

  describe '.initialize' do
    it 'is valid with the correct parameters' do
      expect(paddle).to be_truthy
    end
  end
end