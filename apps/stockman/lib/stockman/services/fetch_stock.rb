module Stockman
  class FetchStock

    attr_accessor :user

    QUANTL_API_BASE = 'https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json'
    QUANTL_API_KEY = ENV.fetch('QUANDL_API_KEY').freeze
    INVALID_DATA = 'Invalid data from Quandl. Please try again'.freeze

    def initialize user:
      @user = user
    end

    def call
      response = HTTParty.get(request_url)

      if response.ok?
        response.parsed_response.dig('datatable', 'data').map {|data| quandl_record data }
      else
        raise INVALID_DATA
      end
    end

    private

    def quandl_record data
      Stockman::QuandlData.new(
        ticker: data[0],
        date:   data[1],
        init:   data[2],
        high:   data[3],
        low:    data[4],
        close:  data[5]
      )
    end

    def request_url
      [
        QUANTL_API_BASE,
        request_params
      ].join('?')
    end

    def request_params
      {
        api_key: QUANTL_API_KEY,
        ticker: user.stock_code,
        'date.gte': user.start_date,
        'date.lte': Date.today.strftime("%Y-%m-%d")
      }.to_query
    end

  end
end
