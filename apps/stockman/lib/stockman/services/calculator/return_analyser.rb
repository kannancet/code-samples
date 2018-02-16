module Stockman
  module Calculator
    class ReturnAnalyser

      attr_accessor :initial_value, :final_value

      def initialize initial_value:, final_value:
        @initial_value = initial_value
        @final_value = final_value
      end

      def call
        percent = ((final_value - initial_value)/initial_value) * 100
        percent.round(2)
      end

    end
  end
end
