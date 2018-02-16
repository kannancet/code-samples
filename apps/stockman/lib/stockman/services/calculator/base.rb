module Stockman
  module Calculator
    class Base

      attr_accessor :quandl_records

      def initialize quandl_records:
        @quandl_records = quandl_records
      end

      def call
        Stockman::Output.new(stock_return: stock_return, stock_drawdown: stock_drawdown)
      end

      private

      def stock_return
        Stockman::Calculator::ReturnAnalyser.new(initial_value: quandl_records.first.init,
                                                 final_value: quandl_records.last.close).call
      end

      def stock_drawdown
        Stockman::Calculator::DrawdownAnalyser.new(stock_values: stock_values).call
      end

      def stock_values
        stock_data_points = quandl_records.inject([quandl_records.first.init]) do |data_points, quandl_record|
          data_points.push(quandl_record.high)
          data_points.push(quandl_record.low)
        end

        stock_data_points.push(quandl_records.last.close)
      end

    end
  end
end
