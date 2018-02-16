module MrabaETL
  module Actions
    class Base

      attr_accessor :mraba_record, :sender, :dtaus

      def initialize mraba_record:
        @mraba_record = mraba_record
        @sender = mraba_record.sender
        @dtaus = mraba_record.dtaus
      end

      Error::TYPES.keys.each do |error_type|
        define_method :"log_error_#{error_type}" do |message|
          mraba_record.errors << build_error_text(error_type, message)
        end
      end

      def build_error_text error_type, message
        Error::TYPES[error_type].gsub('{ACTIVITY_ID}', mraba_record.activity_id.to_s)
                                .gsub('{MESSAGE}', message)
      end

    end
  end
end
