module MrabaETL
  class SFTPDownloaderService

    attr_accessor :entries
    SFTP_REMOTE_ALL_CSV = "/data/files/csv/*.csv"
    LOCAL_SFTP_FOLDER = "#{Rails.root.to_s}/private/data"
    REMOTE_SFTP_FOLDER = "/data/files/csv"

    def initialize
      create_local_download_folder
      build_entries
    end

    def call &parser
      entries.each do |entry|
        $sftp.download! file_remote(entry), file_local(entry)

        yield entry
      end
    end

    private

    def build_entries
      entries_sorted_by_name = $sftp.dir.entries(SFTP_REMOTE_ALL_CSV).sort_by(&:name)
      entry_start_index = entries_sorted_by_name.index{|entry| entry.name.include?('.start') }

      @entries = entries_sorted_by_name[0..entry_start_index].collect(&:name)
    end

    def create_local_download_folder
      FileUtils.mkdir_p LOCAL_SFTP_FOLDER
      FileUtils.mkdir_p "#{LOCAL_SFTP_FOLDER}/download"
    end

    def file_remote entry
      "#{REMOTE_SFTP_FOLDER}/#{entry}"
    end

    def file_local entry
      @file_local ||= "#{LOCAL_SFTP_FOLDER}/download/#{entry}"
    end
  end
end
