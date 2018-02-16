class BackendMailer
  class << self; attr_accessor :all end

  def self.send_import_feedback(*args)
    (BackendMailer.all ||= []) << args.flatten
  end
end
