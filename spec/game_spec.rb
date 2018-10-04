require_relative '../game.rb'

RSpec.describe Game do
  it 'creates a game window' do
    game = Game.new
    expect(game.caption).to eq('Brick Breaker')
  end
end
