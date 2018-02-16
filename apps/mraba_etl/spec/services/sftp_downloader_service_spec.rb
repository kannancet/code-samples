require "spec_helper"

RSpec.describe MrabaETL::SFTPDownloaderService do

  describe "#call" do
    let(:entries) { [] }
    let(:stub_entries) {[double("mraba.csv", name: "mraba.csv"),
                   double("mraba.csv.start", name: "mraba.csv.start"),
                  double("notparsed.csv", name: "notparsed.csv")]}
    before { $sftp.stub_chain(:dir, :entries).and_return(stub_entries) }
    before { $sftp.stub(:download!).and_return(true) }

    it "should download files from SFTP and call parser service" do
      allow_any_instance_of(MrabaETL::SFTPDownloaderService).to receive(:file_remote).and_return("/data/files/csv/mraba.csv.start")
      allow_any_instance_of(MrabaETL::SFTPDownloaderService).to receive(:file_local).and_return("#{Rails.root}/private/data/download/mraba.csv")

      MrabaETL::SFTPDownloaderService.new.call do |name|
        entries << name
      end

      expect(entries).to eq ["mraba.csv", "mraba.csv.start"]
    end

    it "should create local parser source folder" do
      download_folder_created = Dir.exists?("#{Rails.root}/private/data/download")
      expect(download_folder_created).to eq true
    end
  end
end
