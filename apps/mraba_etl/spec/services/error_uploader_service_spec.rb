require "spec_helper"

RSpec.describe MrabaETL::ErrorUploaderService do

  describe "#call" do
    let(:mraba_records) { [] }

    before { $sftp.stub(:upload!).and_return(true) }

    it "should populate error in upload CSV" do
      allow_any_instance_of(AccountTransfer).to receive(:valid?).and_return(false)

      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:bank_transfer?).and_return(false)
        mraba_records << record
      end

      response = MrabaETL::Actions::AddBankTransferService.new(mraba_record: mraba_records.first).call
      MrabaETL::ErrorUploaderService.new(mraba_records: mraba_records).call

      upload_folder_created = Dir.exists?("#{Rails.root}/private/data/upload")
      error = File.open("#{Rails.root}/private/data/upload/mraba.error.csv", "r").read
      expect(error.include?('1: BankTransfer validation error(s): account test error1; account test error1')).to eq true
    end
  end
end
