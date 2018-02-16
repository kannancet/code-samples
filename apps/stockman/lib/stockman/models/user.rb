module Stockman
  class User

    attr_accessor :name, :email, :start_date, :stock_code

    def self.attributes
      [:name, :email, :start_date, :stock_code]
    end
  end
end
