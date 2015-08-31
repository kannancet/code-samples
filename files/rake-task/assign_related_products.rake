namespace :byebuy do
  desc "Assign related products randomly"
  task assign_related_products: :environment do

  	RELATION = Spree::RelationType.find_by_name("Related Products")
  	RELATION_TYPE = RELATION.applies_to

  	#Function to fetch all categories for the store
  	def fetch_all_categories(store)
  		taxons = store.taxonomies.first.try(:taxons)
      if taxons.blank?
        nil
      else
        taxons.find_by_name('categories').try(:children)  
      end
  	end

  	#Function to add product and relation
  	def add_product_and_relation(product)
			if product_not_deleted(product)
				add_different_category_product_to_related_product(product)
			end
		end

  	#Function to add random product from different category
  	def add_different_category_product_to_related_product(product)
      store = product.stores.first
  		unrelated_categories = fetch_all_categories(store).select{|category| category_does_not_belong_to_product?(product, category) }.shuffle.first(4)
      delete_old_and_create_new_relation(product, unrelated_categories)
  	end

  	#Function to delete old and create new relation
  	def delete_old_and_create_new_relation(product, unrelated_categories)
			related_products = build_related_product_list(product, unrelated_categories)
			delete_old_related_products(product)
			save_new_related_products(product, related_products)
		end

  	#Function to delete old relations
  	def delete_old_related_products(product)
  		product.relations.where(relatable_type: RELATION_TYPE, related_to_type: RELATION_TYPE).destroy_all
  	end

  	#Function to save related products
  	def save_new_related_products(product, related_products)
  		p "Product : #{product.name} ==> Taxon : #{product.taxons.flatten.collect(&:id)} ==> Related To : #{related_products.flatten.collect(&:name)} ==> Taxons :#{related_products.flatten.collect(&:taxons).flatten.collect(&:id)}"
  		related_products.each do |related_product|
  			Spree::Relation.find_or_create_by(relation_type: RELATION,
              								 						relatable: product,
              								 						related_to: related_product)
  		end
  	end

  	#Function to build related products list
  	def build_related_product_list(product, unrelated_categories)
      unrelated_categories.inject([]) do |result, category| 
  		  random_products = category.products.reject{|random_category_product| random_category_product.id == product.id}.compact
  		  result << random_products.sample
      end
  	end

  	#Function to check if category does not belong to product
  	def category_does_not_belong_to_product?(product, random_category)
  		(random_category.products.count > 0) && (!product.taxons.include?(random_category))
  	end

  	#Function to check if produ is not deleted
  	def product_not_deleted(product)
  		product.deleted_at.nil?
  	end

  	Spree::Product.find_each do |product|
      store = product.stores.first

      if store 
        p "Adding related for ------------- Product #{product.id} -----------------------------------"
        store_taxons = fetch_all_categories(store)
        add_product_and_relation(product) unless store_taxons.blank?
      end
  	end

  end
end