require_relative '../game'
require 'state'

RSpec.describe Game do
  context 'with a Game instance' do
    let(:game) { Game.new}

    it 'creates a game window' do
      expect(game.caption).to eq('Breakout')
    end

    it 'has an instance of a Bricks object' do
      expect(game.instance_variable_get(:@bricks).first).to be_an_instance_of(Brick)
      expect(game.instance_variable_get(:@bricks)).to be_an(Array)
    end

    it 'has an instance of a Paddle object' do
      expect(game.instance_variable_get(:@paddle)).to be_an_instance_of(Paddle)
    end

    it 'has an instance of a Ball object' do
      expect(game.instance_variable_get(:@balls).first).to be_an_instance_of(Ball)
      expect(game.instance_variable_get(:@balls)).to be_an_instance_of(Array)
    end

    it 'has a background image' do
      expect(game.instance_variable_get(:@background)).to be_an_instance_of(Gosu::Image)
    end

    it 'has the game state set to `ball in paddle`' do
      expect(game.instance_variable_get(:@game_state)).to eq(State::BALL_IN_PADDLE)
    end
  end
end
