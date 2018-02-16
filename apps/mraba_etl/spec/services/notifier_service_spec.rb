require "spec_helper"

RSpec.describe MrabaETL::NotifierService do

  describe "#call" do
    let(:mraba_records) { [] }

    it "should populate error in upload CSV" do
      allow_any_instance_of(AccountTransfer).to receive(:valid?).and_return(false)

      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:bank_transfer?).and_return(false)
        mraba_records << record
      end

      MrabaETL::Actions::AddBankTransferService.new(mraba_record: mraba_records.first).call
      MrabaETL::NotifierService.new(mraba_records: mraba_records).call

      expect(BackendMailer.all.first.first).to eq "Import CSV failed"
    end
  end
end
