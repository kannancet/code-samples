module MrabaETL
  module Actions
    class AddAccountTransferService < Base

      TRUE = true.freeze
      PENDING = 'pending'.freeze

      def call
        return unless mraba_record.sender
        account_transfer, transfer_action = find_or_build_account_transfer
        save_or_complete_transfer(account_transfer, transfer_action)

        mraba_record
      end

      private

      def save_or_complete_transfer account_transfer, transfer_action
        return unless account_transfer
        return account_transfer.send(transfer_action) if account_transfer.valid?
  
        error_messages = account_transfer.errors.full_messages.join(';')
        log_error_account_invalid error_messages
      end

      def find_or_build_account_transfer
        if mraba_record.depot_activity_id.blank?
          return build_account_transfer, :save
        else
          return find_account_transfer, :complete_transfer!
        end
      end

      def find_account_transfer
        account_transfer = sender.credit_account_transfers.find_by_id(mraba_record.depot_activity_id)
        log_error_account_not_found(mraba_record.depot_activiy_id) if account_transfer.blank?
        log_error_account_invalid_state(account_transfer.state) if account_transfer && (account_transfer.state != PENDING)

        account_transfer
      end

      def build_account_transfer
        sender.credit_account_transfers
              .build(amount: mraba_record.amount&.to_f,
                     subject: mraba_record.subject,
                     receiver_multi: mraba_record.receiver_konto,
                     date: Date.parsable?(mraba_record.entry_date) ? mraba_record.entry_date&.to_date : nil,
                     skip_mobile_tan: TRUE)

      end

    end
  end
end
