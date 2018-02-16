module Stockman
  class Output

    attr_accessor :stock_return, :stock_drawdown

    def initialize(stock_return:, stock_drawdown:)
      @stock_return = stock_return
      @stock_drawdown = stock_drawdown
    end

  end
end
