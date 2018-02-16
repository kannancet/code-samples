require "spec_helper"

RSpec.describe MrabaETL::ParserService do

  describe "#call" do
    let(:mraba_records) { [] }

    it "should parse each file and generate mraba records" do
      MrabaETL::ParserService.new(file: "#{Rails.root}/private/data/download/mraba.csv").call do |record|
        mraba_records << record
      end

      expect(mraba_records.size).to eq 5
      expect(mraba_records.first.activity_id).to eq 1
      expect(mraba_records.first.errors.blank?).to eq true
    end
  end
end
