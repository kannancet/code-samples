require "spec_helper"

RSpec.describe Stockman::FetchStock do

  let(:user) { build(:user) }

  it "should fetch data from Quandl" do
    VCR.use_cassette("quandl_fetch_stock", record: :new_episodes) do
      response = Stockman::FetchStock.new(user: user).call

      expect(response.size).to eq 38
      expect(response.first.class).to eq Stockman::QuandlData
    end
  end
end
