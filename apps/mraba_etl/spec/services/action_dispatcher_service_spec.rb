require "spec_helper"

RSpec.describe MrabaETL::ActionDispatcherService do

  describe "#call" do
    let(:mraba_record) { nil }
    let(:processed_mraba_records) { [] }

    it "dispatch actions to #account_transfer" do
      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:account_transfer?).and_return(true)
        processed_mraba_records << MrabaETL::ActionDispatcherService.new(mraba_record: record).call
      end

      expect(processed_mraba_records.size).to eq 5
    end

    it "dispatch actions to #bank_transfer" do
      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:bank_transfer?).and_return(true)
        processed_mraba_records << MrabaETL::ActionDispatcherService.new(mraba_record: record).call
      end

      expect(processed_mraba_records.size).to eq 5
    end

    it "dispatch actions to #lastschrift" do
      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        allow(record).to receive(:lastschrift?).and_return(true)
        processed_mraba_records << MrabaETL::ActionDispatcherService.new(mraba_record: record).call
      end

      expect(processed_mraba_records.size).to eq 5
    end
  end
end
