module MrabaETL
  module Actions
    class AddDTARowService < Base

      INVALID_SENDER = 'Invalid Sender'.freeze

      def call
        return log_error_invalid_sender(INVALID_SENDER) if mraba_record.invalid_sender?

        @holder = Iconv.iconv('ascii//translit', 'utf-8', mraba_record.sender_name).to_s.gsub(/[^\w^\s]/, '')
        add_buchung @holder

        mraba_record
      end

      private
      def add_buchung holder
        mraba_record.dtaus
                    .add_buchung(mraba_record.sender_konto,
                                 mraba_record.sender_blz,
                                 @holder,
                                 BigDecimal(mraba_record.amount).abs,
                                 mraba_record.subject)
      end

    end
  end
end
