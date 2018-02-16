module MrabaETL
  class ParserService

    PARSING_OPTIONS = { encoding: "UTF-8", headers: true, col_sep: ';', header_converters: :symbol, converters: :all}.freeze
    LOCAL_SFTP_FOLDER = "#{Rails.root.to_s}/private/data/download/"
    attr_accessor :file

    def initialize file:
      @file = file
    end

    def call &dispatcher
      build_mraba_accessors file

      CSV.foreach(file, PARSING_OPTIONS) do |row|
        attributes = row.to_hash.merge!(file: file, errors: [])
        mraba_record = MrabaRecord.new attributes

        yield mraba_record
      end
    end

    private
    def build_mraba_accessors file
      headers = CSV.read(file, headers: true).headers
      sanitised_headers = headers.map(&:downcase).first&.split(';')

      MrabaRecord.build_accessors(sanitised_headers.push(:file, :errors)) if sanitised_headers
    end

  end
end
