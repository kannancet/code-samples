require "spec_helper"

RSpec.describe MrabaETL do
  describe "#start" do

    let(:stub_entries) {[double("mraba.csv", name: "mraba.csv"),
                   double("mraba.csv.start", name: "mraba.csv.start"),
                  double("notparsed.csv", name: "notparsed.csv")]}
    before { $sftp.stub_chain(:dir, :entries).and_return(stub_entries) }
    before { $sftp.stub(:download!).and_return(true) }
    before { $sftp.stub(:upload!).and_return(true) }
    
    it "should parse each file and generate mraba records" do
      response = MrabaETL.start
      expect(response).to eq ["mraba.csv", "mraba.csv.start"]
    end
  end
end
