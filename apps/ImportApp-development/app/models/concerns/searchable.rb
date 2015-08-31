#This module implements search data 
module Searchable
  extend ActiveSupport::Concern

  #All class methods are defined here.
  module ClassMethods

	  #Function to search data
	  def search_data(query, company_id)
	    unless query.blank? 
	      search query, where: {company_id: company_id}, 
	                    fields: [:reporter, :invoice_num, :status, :kind], 
	                    limit: 10
	    else
	      Operation.where(company_id: company_id)
	    end
	  end

	end
end