=begin
  This class is used to sync open erp data for all Models
  This class sync all models defined in table openerp_mappings
=end
class OpenerpData

  class << self

    #Function to print info on mapping
    def print_syncing(openerp_model, rails_model)
    	p "Syncing OpenERP model #{openerp_model} with WebStore model #{rails_model} ..."
    end

    #Function to initiate sync of data on each Mapping
    def sync
      OPENERP_MAPPING_SEED.map do |openerp_model, rails_data|
        rails_model = rails_data.camelize.constantize
        
        print_syncing(openerp_model, rails_model)
        rails_model.sync(openerp_model) 

      end
    end

  end

end 