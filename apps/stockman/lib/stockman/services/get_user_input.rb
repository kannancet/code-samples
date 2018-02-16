module Stockman
  class GetUserInput
    attr_accessor :user

    def initialize
      @user = User.new
    end

    def ask_name
      puts "Welcome to stockman! Your good name please ?"
      user.name = gets.chomp
    end

    def ask_email
      puts "Your email address ?"
      email = gets.chomp

      if email.is_email?
        user.email = email
      else
        puts "Sorry! You entered a wrong email format. Please retry"
        ask_email
      end
    end

    def ask_stock_code
      puts "Please give the stock code. Eg: AAPL"
      user.stock_code = gets.chomp
    end

    def ask_start_date
      puts "Please give your preferred start date. Eg: DD-MM-YYYY ?"
      date = gets.chomp

      if Date.parsable?(date)
        user.start_date = Time.parse(date).strftime("%Y-%m-%d")
      else
        puts "Sorry! You entered a wrong date format. Please retry"
        ask_start_date
      end
    end

    def call
      User.attributes.each do |attr|
        send "ask_#{attr}"
      end

      user
    end
  end
end
