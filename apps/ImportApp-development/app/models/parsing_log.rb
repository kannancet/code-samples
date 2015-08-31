class ParsingLog < ActiveRecord::Base

  has_attached_file :operation_file
  validates_attachment_content_type :operation_file, :content_type => ["text/csv"]
  after_create :set_efault_counts

  #Function to set default counts after create
  def set_efault_counts
  	update(total_rows_suceeded: 0, total_rows_failed: 0, total_rows_parsed: 0)
  end

  #Find running parsers
  def self.running_parser
  	where(status: "parsing")
  end
end
