module Stockman
  module Calculator
    class DrawdownAnalyser

      attr_accessor :stock_values

      def initialize stock_values:
        @stock_values = stock_values
      end

      def call
        percent = ((biggest_drop.max - biggest_drop.min) / biggest_drop.max) * 100
        percent.round(2)
      end

      private

      def biggest_drop
        @biggest_drop ||=
          high_to_high_values.map { |high_to_high| Range.new(*high_to_high.minmax) }
                             .max_by { |range| range.max - range.min }
      end

      def high_to_high_values
        result_values = []
        stock_values_copy = stock_values.dup

        until stock_values_copy.empty? do
          result_values << stock_values_copy.slice!(stock_values_copy.index(stock_values_copy.max)..-1)
        end

        result_values.reverse
      end

    end
  end
end
