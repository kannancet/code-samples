module Mraba
  class Transaction
    class << self; attr_accessor :all end

    def self.define_dtaus(*args)
      new
    end

    def valid_sender?(*)
    end

    def add_buchung(*)
      (Mraba::Transaction.all ||= []) << self
    end

    def add_datei(*)
    end
  end
end
