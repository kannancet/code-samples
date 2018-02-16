require_relative 'stockman/dependencies'

module Stockman
  class << self

    def start
      user = Stockman::GetUserInput.new.call
      quandl_records = Stockman::FetchStock.new(user: user).call
      output = Stockman::Calculator::Base.new(quandl_records: quandl_records).call

      Stockman::UserNotifier.new(user: user, output: output).call
      announce_results user, output
    end

    private
    
    def announce_results user, output
      puts "Hi #{user.name}, Your stockman results are ready!"
      puts "RETURN RATE is #{output.stock_return}% and DRAWDOWN RATE is #{output.stock_drawdown}%."
      puts "Stockman has send the results to the email #{user.email}."
    end
  end
end
