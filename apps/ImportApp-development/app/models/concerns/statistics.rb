#This module import data 
module Statistics
  extend ActiveSupport::Concern

  #Function to show operation acount
  def operation_count
  	operations.count
  end

  #Find average amount of operations
  def average_amount_operations
  	if operations.any?
  	  total = operations.sum(:amount)
  	  count = operations.count
  	  total/count
  	end
  end

  #Function to find highest operation this month.
  def highest_operation_this_month
  	if operations.any?
  	  highest_ops = operations.order("amount DESC").first
  	  largest_operation_info(highest_ops)
  	end
  end

  #Return string info of largest Operation
  def largest_operation_info(highest_ops)
  	"##{highest_ops.id} - #{highest_ops.invoice_num} - $ #{highest_ops.amount}"
  end

  #Accepted operations count
  def accepted_operations_count
  	operations.where(status: "accepted").count
  end

end