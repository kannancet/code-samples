require "spec_helper"

RSpec.describe Stockman::UserNotifier do

  let(:user) { build(:user) }

  it "should fetch data from Quandl" do
    VCR.use_cassette("quandl_fetch_stock", record: :new_episodes) do
      quandl_records = Stockman::FetchStock.new(user: user).call
      output = Stockman::Calculator::Base.new(quandl_records: quandl_records).call
      response = Stockman::UserNotifier.new(user: user, output: output).call

      expect(response.class).to eq Mail::Message
      expect(Mail::TestMailer.deliveries.length).to eq 1
    end
  end
end
