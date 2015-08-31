
#This module implements download from URL
module Downloadable
  extend ActiveSupport::Concern

  #All class methods are defined here.
  module ClassMethods

    #Function to validate user input for URL
    def is_a_csv_url(url)
  	extension = File.extname(URI.parse(url).path)
  	(url =~ URI::regexp) && (extension == ".csv")
    end

    #Function to save file from url
    def save_file(url)
    	puts "Downloading file from URL ..."
  	  file_name = url.split("/").last
  	  file_path = "#{Rails.root}/public/#{file_name}"
      
      open(file_path, 'wb') do |file|
        file << open(url).read
      end  

      file_path	
    end

    #Function to download operation file from URL
    def download_file(url)
    	if is_a_csv_url(url)
    	  return save_file(url)
    	else
    	  raise "Invalid URL input. Input should be URL with .csv extension"
  	  end
    end

  end

end