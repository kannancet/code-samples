class Date
  def self.parsable?(string)
    begin
      parse(string.to_s)
      true
    rescue ArgumentError
      false
    end
  end
end
