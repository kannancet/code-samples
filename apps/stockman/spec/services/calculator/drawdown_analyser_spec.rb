require "spec_helper"

RSpec.describe Stockman::Calculator::DrawdownAnalyser do

  let(:stock_values) {  [169.95, 171.67, 168.5, 172.62, 169.63, 171.52, 168.4, 170.2047, 166.46, 170.44, 168.91, 171.0, 168.82] }

  it "should find drawdonw value" do
    response = Stockman::Calculator::DrawdownAnalyser.new(stock_values: stock_values).call
    expect(response).to eq 3.57
  end
end
