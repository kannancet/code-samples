require "spec_helper"

RSpec.describe Stockman::Calculator::ReturnAnalyser do

  it "should find returns" do
    response = Stockman::Calculator::ReturnAnalyser.new(initial_value: 1, final_value: 5).call
    expect(response).to eq 400
  end
end
