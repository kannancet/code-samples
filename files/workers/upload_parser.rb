class UploadParser
  @queue = :parser_queue

  def self.perform(parsing_log_id)
  	@log = ParsingLog.find(parsing_log_id)
  	file = @log.operation_file.path
  	data = GoogleKeyword.import_data(file, @log.id)
  	GoogleKeyword.browse_and_save_information(data)
  end
end