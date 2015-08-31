#This module implements import data 
module Importable
  extend ActiveSupport::Concern

  #All class methods are defined here.
  module ClassMethods

    PARSING_ROW_INCREMENT_COUNT = 1
    PARSING_ROW_DEFAULT_COUNT = 0

    #Function to import operations from CSV.
    def import(file, parsing_log_id = new_parsing_log_id)
      notify_on_parsing_log
      @log = ParsingLog.find(parsing_log_id)

      SmarterCSV.process(file) do |data|
        data = data.first
        sync_data(data)
      end

      update_parsinglog_status
    end

    #Function to update parsing log status
    def update_parsinglog_status
      @log.update(status: "complete")
    end

    #Function to create new parsing log if parsing log id nil
    def new_parsing_log_id
      log = ParsingLog.create(total_rows_failed: 0, total_rows_suceeded: 0, total_rows_parsed: 0)
      log.id
    end

    #Function to increment parsing log success
    def increment_parsing_log_success
      success_count = (@log.total_rows_suceeded || PARSING_ROW_DEFAULT_COUNT) + PARSING_ROW_INCREMENT_COUNT
      total_count = (@log.total_rows_failed || PARSING_ROW_DEFAULT_COUNT) + success_count
      @log.update(total_rows_suceeded: success_count, total_rows_parsed: total_count)
    end

    #Function to increment parsing log error
    def increment_parsing_log_failed
      failed_count = (@log.total_rows_failed || PARSING_ROW_DEFAULT_COUNT) + PARSING_ROW_INCREMENT_COUNT
      total_count = (@log.total_rows_suceeded || PARSING_ROW_DEFAULT_COUNT) + failed_count
      @log.update(total_rows_failed: failed_count, total_rows_parsed: total_count)
    end

    #Function to sync data
    def sync_data(data)
      begin
        operation = create_operation(data)
        sync_categories(operation) if operation.kind
        increment_parsing_log_success

      rescue Exception => e
        increment_parsing_log_failed
        log_data_invalid_error(data, e)
      end

      notify_pusher
    end

    #Function to notify pusher on reltime status
    def notify_pusher
      Pusher['parsing_log'].trigger('parse_operations', {
        success_rows: @log.total_rows_suceeded || PARSING_ROW_DEFAULT_COUNT,
        failed_rows: @log.total_rows_failed || PARSING_ROW_DEFAULT_COUNT,
        total_rows: @log.total_rows_parsed || PARSING_ROW_DEFAULT_COUNT,
        status: @log.status,
        id: @log.id
      })      
    end

    #Function to find company from name and return company_id
    def find_company_id(name)
      @company = Company.find_or_create_by(name: name)
      @company.id
    end

    #Function to parse data
    def parse_date(date_string)
      selected_format = DATE_FORMATS.select{|date_format| date_string =~ date_format[:format]}[0]
      Date.strptime(date_string, selected_format[:type]) if selected_format
    end

    #Function to sync categories
    def sync_categories(operation)
      category_names = operation.kind.split(";")

      category_names.each do |name| 
        category = find_or_create_category(name)
        category.operations.push(operation)
      end
    end

    #Function to find or create category
    def find_or_create_category(name)
      Category.find_or_create_by(name: name)
    end

    #Notify on parsing log
    def notify_on_parsing_log
      open(OPERATION_IMPORT_LOG, 'a') do |file|
        file.truncate(0)
        file.puts "<<<<<<<<< PARSING LOG AT : #{Time.now} >>>>>>>>>"
      end
    end

    #Function to retrun data invalid error.
    def log_data_invalid_error(data, exception)
      open(OPERATION_IMPORT_LOG, 'a') do |file|

        file.puts "==== DATA INVALID ===="
        file.puts "Skipping Invoice #{data[:invoice_num]} of company #{data[:company]}"
        file.puts "Reason - #{exception.message}"
      end
    end

    #Function to create operation
    def create_operation(data)
      puts "Importing Operation #{data[:invoice_num]}"
      Operation.find_or_create_by(company_id: find_company_id(data[:company]),
                    invoice_num: data[:invoice_num],
                    invoice_date: parse_date(data[:invoice_date]),
                    operation_date: parse_date(data[:operation_date]),
                    amount: data[:amount] || 1.0,
                    reporter: data[:reporter],
                    notes: data[:notes],
                    status: data[:status],
                    kind: data[:kind] 
                    )
    end

  end

end