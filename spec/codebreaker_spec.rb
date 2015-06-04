require 'spec_helper'

describe Codebreaker::Game do

  before :all do
    @game = Codebreaker::Game.new(6, 4, 999)
  end

  it 'has a version number' do
    expect(Codebreaker::VERSION).not_to be nil
  end

  describe "#start" do
    before do
      @secret_code = @game.start
    end

    it "returns code" do
      expect(@secret_code).not_to be_empty
    end

    it "returns 1-6 only" do
       expect(@secret_code).to match(/[1-6]$/)
    end


    it "returns 4 digits code, 1-6 only" do
      expect(@secret_code).to match(/[1-6]{4}$/)
    end

    it "generates new code with each round" do
      new_code = Codebreaker::Game.new.start
      expect(@secret_code).not_to eq(new_code)
    end

    it "resets hint" do
      expect(@game.hint).to be_truthy
      expect(@game.hint).to be_falsy
      @game.start
      expect(@game.hint).to be_truthy
    end
    
  end

  describe "#hint" do

    before do
      @game.start
      @hint = @game.hint
    end

    it "returns 1 digit" do
      expect(@hint.to_s).to match(/[1-6]/)
    end

    it "can be called only once" do
      game = Codebreaker::Game.new
      game.start

      expect(game.hint).to be_truthy
      expect(game.hint).to be_falsy
    end
  end

  describe "#check" do

    context "basic" do

      before :all do
        @game.start
        @game.send(:set_code, "1234")
      end

      it "returns a string" do
        expect(@game.check('1234')).to be_an_instance_of(String)
      end

      it "contains only '+', '-' or an empty string"  do
        expect(@game.check("1234")).to match(/[+-]*/)
      end

      it "is not longer than 4 symbols" do
        expect(@game.check("1234").length).to be <= 4
      end

      it "should not raise error when input is valid" do
        expect{@game.check("1111")}.to_not raise_error
      end

      it "counts number of attempts" do
        attempts = @game.attempts
        expect { @game.check("1111") }.to change{@game.attempts}.from(attempts).to(attempts+1)
      end
    end

    context "input validation", focus: true do
      it "should return valid results" do
        @game.start
        
        @game.send(:set_code, "1234")
        expect(@game.check("1111")).to eq("+")
        expect(@game.check("5651")).to eq("-")
        expect(@game.check("5631")).to eq("+-")
        expect(@game.check("4321")).to eq("----")
        expect(@game.check("3346")).to eq("--")
        expect(@game.check("5555")).to eq("")
        expect(@game.check("3344")).to eq("+-")

        @game.send(:set_code, "3333")
        expect(@game.check("6566")).to eq("")
        expect(@game.check("3344")).to eq("++")
        expect(@game.check("1243")).to eq("+")
        expect(@game.check("1313")).to eq("++")
        expect(@game.check("2453")).to eq("+")

        @game.send(:set_code, "2323")
        expect(@game.check("6514")).to eq("")
        expect(@game.check("5544")).to eq("")
        expect(@game.check("2233")).to eq("++--")
        expect(@game.check("2323")).to eq("++++")
      end
    end
  end
end