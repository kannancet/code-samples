module Stockman
  class QuandlData

    attr_accessor :ticker,
                  :date,
                  :init,
                  :high,
                  :low,
                  :close

    def initialize(ticker:, date:, init:, high:, low:, close:)
      @ticker = ticker
      @date = date
      @init = init
      @high = high
      @low = low
      @close = close
    end
  end
end
