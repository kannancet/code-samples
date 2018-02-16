require "spec_helper"

RSpec.describe Stockman::QuandlData do

  subject { Stockman::QuandlData.new(ticker: 'AAPL', date: '12-12-2017', init: 1, low: 1, high: 4, close: 1) }
  it { should have_attr_accessor(:ticker) }
  it { should have_attr_accessor(:date) }
  it { should have_attr_accessor(:init) }
  it { should have_attr_accessor(:low) }
  it { should have_attr_accessor(:high) }
  it { should have_attr_accessor(:close) }

end
