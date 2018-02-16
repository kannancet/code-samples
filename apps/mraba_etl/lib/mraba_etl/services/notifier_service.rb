module MrabaETL
  class NotifierService

    attr_accessor :mraba_records, :entry
    IMPORT_SUCCESS = 'Successful Import'.freeze
    IMPORT_FAILED = 'Import CSV failed'.freeze

    def initialize mraba_records:
      @mraba_records = mraba_records
      @entry = mraba_records.first&.file
    end

    def call
      return unless entry
      
      if import_success?
        BackendMailer.send_import_feedback(IMPORT_SUCCESS, import_success_message_header)
      else
        error_content = errors.join("\n")
        BackendMailer.send_import_feedback(IMPORT_FAILED, import_fail_message(error_content))
      end
    end

    private

    def import_success?
      errors.blank?
    end

    def errors
      @errors ||= mraba_records.collect(&:errors).flatten
    end

    def import_fail_message error_content
      "Import of the file #{entry} failed with errors: #{error_content}"
    end

    def import_success_message_header
      "Import of the file #{entry} done."
    end

  end
end
