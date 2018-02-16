require "spec_helper"

RSpec.describe Stockman::Output do

  subject { Stockman::Output.new(stock_return: 1, stock_drawdown: 2) }
  it { should have_attr_accessor(:stock_drawdown) }
  it { should have_attr_accessor(:stock_return) }

end
