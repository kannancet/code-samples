class AccountTransfer

  class << self; attr_accessor :all end

  attr_accessor :amount, :subject, :receiver_multi, :date, :skip_mobile_tan, :rec_holder, :rec_holder, :rec_holder

  def initialize args
    @amount = args[:amount]
    @subject = args[:subject]
    @receiver_multi = args[:receiver_multi]
    @ate = args[:date]
    @skip_mobile_tan = args[:skip_mobile_tan]
    @rec_holder = args[:rec_holder]
    @rec_account_number = args[:rec_holder]
    @rec_bank_code = args[:rec_holder]
  end

  def self.credit_account_transfers(*)
    AccountTransferBuilder
  end

  def self.build_transfer args
    new args
  end

  def save
    (AccountTransfer.all ||= []) << self
    self
  end

  def save!
    save
  end

  def valid?
    is_a?(AccountTransfer)
  end

  def errors
    AccountTransferErrorBuilder
  end

end
