module MrabaETL
  class ErrorUploaderService

    LOCAL_ERROR_UPLOAD_PATH = "#{Rails.root.to_s}/private/data/upload"
    SFTP_ERROR_UPLOAD_PATH = "/data/files/batch_processed"

    attr_accessor :mraba_records, :entry

    def initialize mraba_records:
      @mraba_records = mraba_records
      @entry = mraba_records.first&.file
    end

    def call
      return unless entry
      FileUtils.mkdir_p LOCAL_ERROR_UPLOAD_PATH

      write_to_error_file errors
      $sftp.upload!(upload_error_file, "#{SFTP_ERROR_UPLOAD_PATH}/#{File.basename(entry)}")
    end

    private

    def write_to_error_file errors
      error_content = [error_message_header(entry), errors].flatten.join("\n")
      open(upload_error_file, 'w') { |file|
        file.puts error_content
      }

      upload_error_file
    end

    def upload_error_file
      @upload_error_file ||= "#{LOCAL_ERROR_UPLOAD_PATH}/#{File.basename(entry).gsub('.csv', '.error.csv')}"
    end

    def errors
      @errors ||= mraba_records.collect(&:errors).flatten
    end

    def error_message_header entry
      "Import of the file #{entry} failed with errors:"
    end

  end
end
