class MrabaRecord

  ACCOUNT_TRANSFER_KEY = '00000000'.freeze
  BANK_TRANSFER_KEY = '70022200'.freeze
  UMSATZ_KEY1 = ['16'].freeze
  UMSATZ_KEY2 = '10'.freeze
  DTAUS_PARAM1 = 'RS'.freeze
  DTAUS_PARAM2 = 8888888888.freeze
  DTAUS_PARAM3 = 99999999.freeze
  DTAUS_PARAM4 = 'Credit collection'.freeze

  define_method :initialize do |args|
    args.map do |attribute_name, value|
      self.instance_variable_set("@#{attribute_name}".to_sym, value)
    end
  end

  def self.build_accessors args
    args.each do |arg|
      self.class_eval("def #{arg};@#{arg};end")
      self.class_eval("def #{arg}=(val);@#{arg}=val;end")
    end
  end

  def sender
    Account.find_by_account_no sender_konto
  end

  def dtaus
    @dtaus ||= Mraba::Transaction.define_dtaus(DTAUS_PARAM1, DTAUS_PARAM2, DTAUS_PARAM3, DTAUS_PARAM4)
  end

  def invalid_sender?
    dtaus.valid_sender? sender_konto, sender_blz
  end

  def subject
    self.instance_values.symbolize_keys.map do |key , val|
      val if key.to_s.include?('desc')
    end.compact.join
  end

  def account_transfer?
    (sender_blz == ACCOUNT_TRANSFER_KEY) && (receiver_blz == ACCOUNT_TRANSFER_KEY)
  end

  def bank_transfer?
    (sender_blz == ACCOUNT_TRANSFER_KEY) && (umsatz_key == UMSATZ_KEY2)
  end

  def lastschrift?
    (receiver_blz == BANK_TRANSFER_KEY) && (UMSATZ_KEY1.include?(umsatz_key))
  end

end
