require "spec_helper"

RSpec.describe MrabaETL::Actions::AddAccountTransferService do

  describe "#call" do
    let(:mraba_records) { [] }

    it "should return mraba_record after processing" do
      AccountTransfer.all = []
      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:account_transfer?).and_return(true)
        mraba_records << record
      end

      response = MrabaETL::Actions::AddAccountTransferService.new(mraba_record: mraba_records.first).call
      expect(response).to eq mraba_records.first
      expect(AccountTransfer.all.size).to eq (1)
    end

    it "should generate errors if account_transfer is invalid" do
      allow_any_instance_of(AccountTransfer).to receive(:valid?).and_return(false)

      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:account_transfer?).and_return(false)
        mraba_records << record
      end

      response = MrabaETL::Actions::AddAccountTransferService.new(mraba_record: mraba_records.first).call
      expect(response.errors).to eq ["1: AccountTransfer validation error(s): account test error1;account test error1"]
    end
  end
end
