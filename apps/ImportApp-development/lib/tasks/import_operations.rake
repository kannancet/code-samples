=begin
  This task to import all operations from CSV.
  Models - Operations, Category
=end

namespace :import do
  
  desc "Process to import operations from CSV."
  task :operations => :environment do
    
    begin
      puts "Please give the URL of operation file. Eg: http://monterail-share.s3.amazonaws.com/ImporterAppExample.csv"
      url = STDIN.gets.chomp
      file = Operation.download_file(url)

      puts "Importing operations data ..."
      Operation.import(file)
    rescue Exception => e
      puts e.message
    end

  end
  
end