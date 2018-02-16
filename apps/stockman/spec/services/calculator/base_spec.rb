require "spec_helper"

RSpec.describe Stockman::Calculator::Base do

  let(:user) { build(:user) }

  it "should fetch data from Quandl" do
    VCR.use_cassette("quandl_fetch_stock", record: :new_episodes) do
      quandl_records = Stockman::FetchStock.new(user: user).call
      response = Stockman::Calculator::Base.new(quandl_records: quandl_records).call

      expect(response.class).to eq Stockman::Output
      expect(response.stock_drawdown).to eq 5.57
      expect(response.stock_return).to eq 0.92
    end
  end
end
