class AccountTransferBuilder

  def self.build args
    AccountTransfer.new(amount: args[:amount], subject: args[:subject], receiver_multi: args[:receiver_multi],
                        date: args[:date], skip_mobile_tan: args[:skip_mobile_tan], rec_holder: args[:rec_holder],
                        rec_account_number: args[:rec_account_number], rec_bank_code: args[:rec_bank_code])
  end
end
