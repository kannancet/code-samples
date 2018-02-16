require "spec_helper"

RSpec.describe MrabaETL::Actions::AddDTARowService do

  describe "#call" do
    let(:mraba_records) { [] }
    let(:mraba_transaction_count) { Mraba::Transaction.all.size }

    it "should return mraba_record after processing" do
      Mraba::Transaction.all = []

      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:invalid_sender?).and_return(false)
        mraba_records << record
      end

      response = MrabaETL::Actions::AddDTARowService.new(mraba_record: mraba_records.first).call
      expect(response).to eq mraba_records.first
      expect(Mraba::Transaction.all.size).to eq 1
    end

    it "should generate errors if bank_transfer is invalid" do
      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:invalid_sender?).and_return(true)
        mraba_records << record
      end

      MrabaETL::Actions::AddDTARowService.new(mraba_record: mraba_records.first).call
      expect(mraba_records.first.errors).to eq ["1: BLZ/Konto not valid, csv fiile not written Invalid Sender"]
    end
  end
end
