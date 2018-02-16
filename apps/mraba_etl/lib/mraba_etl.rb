require_relative 'mraba_etl/dependencies'

module MrabaETL
  class << self

    def start
      MrabaETL::SFTPDownloaderService.new.call do |file|
        notify_and_upload_error process_mraba_records("#{Rails.root}/private/data/download/#{file}")
      end
    end

    private

    def process_mraba_records file
      mraba_records = []

      MrabaETL::ParserService.new(file: file).call do |mraba_record|
        begin
          mraba_records << MrabaETL::ActionDispatcherService.new(mraba_record: mraba_record).call
        rescue Exception => e
          mraba_record.errors.push(e.message)
          mraba_records << mraba_record
        end
      end

      mraba_records
    end

    def notify_and_upload_error mraba_records
      MrabaETL::NotifierService.new(mraba_records: mraba_records).call
      MrabaETL::ErrorUploaderService.new(mraba_records: mraba_records).call
    end
  end
end
