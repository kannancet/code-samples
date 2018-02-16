module MrabaETL
  module Actions
    class AddBankTransferService < Base

      def call
        return unless @sender

        if bank_transfer.valid?
          bank_transfer.save!
        else
          build_error_message bank_transfer
        end

        mraba_record
      end

      private

      def build_error_message bank_transfer
        error_messages = bank_transfer.errors.full_messages.join('; ')
        log_error_bank_transfer_invalid error_messages
      end

      def bank_transfer
        @transfer ||= sender.build_transfer(amount: mraba_record.amount&.to_f,
                                            subject: mraba_record.subject,
                                            rec_holder: mraba_record.receiver_name,
                                            rec_account_number: mraba_record.receiver_konto,
                                            rec_bank_code: mraba_record.receiver_blz)

      end

    end
  end
end
