#This module implements CSV downloading for operations
module CSVDownloadable
  extend ActiveSupport::Concern

  #All Instance methods are defined here.
  #module InstanceMethods

    #Function to build operation line
    def build_csv_line
        [company.name,
         invoice_num,
         format_date(invoice_date),
         format_date(operation_date),
         amount.to_f,
         reporter,
         notes,
         status,
         get_categories]
    end

    #Function to create date format in YYYY-MM-DD
    def format_date(date)
      "#{date.year}-#{date.month}-#{date.day}"
    end

    #Function to get categories
    def get_categories
      if categories.blank?
        ""
      else
        categories.uniq.collect(&:name).join(";")
      end
    end


  #All class methods are defined here.
  module ClassMethods

    #Function to build CSV file
    def build_csv
      CSV.open(CSV_TEMPLATE, "wb") do |csv|

        csv << CSV_TEMPLATE_HEADER
        @operations.each do |operation|
          csv << operation.build_csv_line
        end

      end 
    end

    #Create CSV file
    def create_csv(query, company_id) 
      @operations = search_data(query, company_id) 
      build_csv
      CSV_TEMPLATE  
    end

  end

end