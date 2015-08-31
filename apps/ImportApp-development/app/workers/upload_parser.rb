class UploadParser
  @queue = :parser_queue

  def self.perform(parsing_log_id)
  	@log = ParsingLog.find(parsing_log_id)
  	file = @log.operation_file.path
  	Operation.import(file, @log.id)
  end
end