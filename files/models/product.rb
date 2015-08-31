class Product < ActiveRecord::Base

  has_many :product_images, dependent: :destroy
  belongs_to :category
  has_many :product_store_roles
  has_many :store_roles, through: :product_store_roles
  
  has_many :products_shopping_carts
  has_many :shopping_carts, through: :products_shopping_carts
  has_many :product_variants
  has_many :color_codes, through: :product_variants
  
  has_and_belongs_to_many :wishlists
  
  after_create :upload_image
  after_save :ensure_variant_and_color_code
  after_save :assign_role

  paginates_per 20

  #Enabling fulltext search
  searchkick

  #Making URLs pretty
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  default_scope { friendly }

  include Syncable

  #Function to push broker store role
  def push_broker_storerole
    store_roles.find_or_create_by(store_id: FN_BROKER_STORE_ROLE.store_id, 
                                  role_id: FN_BROKER_STORE_ROLE.role_id)
  end

  #Function to push staff store role
  def push_staff_storerole
    store_roles.find_or_create_by(store_id: FN_STAFF_STORE_ROLE.store_id, 
                                  role_id: FN_STAFF_STORE_ROLE.role_id)
  end

  #Function to assign role to product
  def assign_role
    store_roles.destroy_all
    
    case x_brokerstaff 
    when "Broker"
      push_broker_storerole
    when "Staff"
      push_staff_storerole
    when "Broker/Staff"
      push_staff_storerole && push_broker_storerole
    end
  end

  #Function to find actual color
  def actual_color
    ColorCode.where(numeric_code: default_code.split("-")[-2])[0]
  end

  #Function to find real variants
  def real_variants
    Product.where(openerp_id: product_variants.collect(&:openerpid)).order('id ASC').uniq
  end

  #Function to find color codes
  def find_color_codes
    color_codes.uniq(&:numeric_code)
  end

  #Find unique sized products
  def uniq_sizes
    real_variants.uniq(&:size)
  end

  #Function to ensure variants
  def ensure_variant_and_color_code
    flush_variants
    if product_code
      variant_ids = ProductProduct.search([['default_code', 'ilike', "FN-#{product_code.split("-")[0]}"]])
      variant_codes = ProductProduct.find(variant_ids).collect(&:default_code)

      variant_codes.each_with_index do |code, index|
        product_variants.create(openerpid: variant_ids[index], 
                                default_code: code,
                                color_code_id: ensure_color_code(code))  
      end
    end
  end

  #Function to flush all vairants 
  def flush_variants
    product_variants.destroy_all
    color_codes.destroy_all
  end

  #Function to ensure color codes
  def ensure_color_code(code)
    color_code = code.split("-")[-2]
    @color_code = ColorCode.where(numeric_code: color_code)[0]
    @color_code.blank? ?  nil : @color_code.id
  end

  #Function to show releated products
  def related_products(current_customer)
    role_id = current_customer.store_role.role_id
    store_id = current_customer.store_role.store_id
    Product.includes(:product_images).joins(store_roles: [:store, :role]).where("stores.id = ? AND roles.id = ? AND products.category_id = ? AND products.id != ?", store_id, role_id, category_id, id).last(9)
  end


  #Function to show category_products
  def self.category_products(categ_id, current_customer, page, order = PRODUCT_SORT_MODE_DEFAULT)
    role_id = current_customer.store_role.role_id
    store_id = current_customer.store_role.store_id
    categories = Category.friendly.find(categ_id).all_subordinate_ids + [categ_id]

    Product.includes(:product_images)
          .joins(store_roles: [:store, :role])
          .where("stores.id = ? AND roles.id = ? AND products.category_id IN (?)", store_id, role_id, categories)
          .order(find_order(order))
          .page(page).per(12)
  end

  #Function to filter products using query params
  def self.filter_products(current_customer, query_param)
    order = find_order(query_param[:sort_mode])
    query = find_query(query_param)
    page = query_param[:page]
    Product.includes(:product_images, :category)
           .joins(:color_codes, store_roles: [:store, :role])
           .where(query)
           .select(select_fields)
           .order(order)
           .page(page).per(12)
  end

  #Function to select fields by distict
  def self.select_fields
    "products.id, products.slug, products.is_new, products.size, products.description, products.product_code, products.offer_percentage, products.name, products.category_id, products.price"
  end

  #Function for Club all filter queries
  def self.find_query(query_param) 
    query = []
    query << find_storerole_query(query_param[:store_id], query_param[:role_id])
    query << find_category_query(query_param[:category_id])
    query << find_price_query(query_param[:price_mode])
    query << find_color_query(query_param[:color_mode])
    query << find_discount_query(query_param[:discount_mode])
    query.reject{|element| element.blank?}.join(" AND ")
  end 

  #Function to filter based on store roles
  def self.find_storerole_query(store_id, role_id)
    "stores.id = #{store_id} AND roles.id = #{role_id}"
  end

  #Function to find the category
  def self.find_category_query(category_id)
    @category = Category.find(category_id)
    all_subcategories = @category.all_subordinate_ids
    categories = all_subcategories.push(@category.id)

    "products.category_id IN (#{categories.join(",")})"
  end

  #Fuction to find product query
  def self.find_product_query(product_ids)
    if product_ids.blank?
      ""
    else
      product_ids = product_ids.split(",")
      product_ids.blank? ? "" : "products.id IN (#{product_ids.join(",")})"
    end
  end

  #Fucntion to find color query
  def self.find_color_query(color_mode = [])
    if color_mode.blank? 
      ""
    else
      color_mode = color_mode.collect do |color| 
                      "( products.default_code LIKE concat('%', '#{color}', '%') )"
                   end
      query = color_mode.join(" OR ")
      query
    end
  end

  #Function to find discount query
  def self.find_discount_query(discount_mode)
    if discount_mode.blank? 
      ""
    else
      if discount_mode.strip == "Discounted items"
        " products.offer_percentage IS NOT NULL "
      else
        " products.offer_percentage IS NULL "
      end
    end
  end

  #Function to find order
  def self.find_price_query(price_mode)
    price_query = []
    if price_mode.blank? 
      ""
    else
      price_mode = price_mode.tr('^0-9', '-').split("-").reject { |c| c.blank? }

      greater =  price_mode ? price_mode[0] : nil
      lesser = price_mode ? price_mode[1] : nil
      price_query << (greater.blank? ? "" : "(products.price = #{greater} OR products.price > #{greater})")
      price_query << (lesser.blank? ? "" : "(products.price = #{lesser} OR products.price < #{lesser})")
      price_query.reject{|element| element.blank?}.join(" AND ")
    end
  end

  #Fucntion to find order
  def self.find_order(order)
    case order
    when "Default sorting"
      "products.id ASC"
    when "Sort by popularity"
      "RANDOM()"
    when "Sort by average rating"
      "RANDOM()"
    when "Sort by newness"
      "products.created_at DESC"
    when "Sort by price: low to high"
      "products.price ASC"
    when "Sort by price: high to low"
      "products.price DESC"
    end
  end


  #Check if product has promotion
  def has_promotion?
    !offer_percentage.blank?
  end

  #Function to show product tile image on home page with place holder
  def tile_image
    product_images.any? ? product_images[0].image_url : "product-img-placeholder.jpg"
  end

  #Find the roles in which a product is available in a store
  def roles
    Role.joins(store_roles: [:products, :store]).where("products.id = ?", id).group_by("stores.name")
  end

  #Method to prepare params for each record of category
  def self.mapping_params(data)
    save_image(data)
    {
      name: data.name,
      description: data.description,
      standard_price: data.standard_price,
      price: data.list_price,
      list_price: data.list_price,
      product_code: find_product_code(data),
      details:  data.description,
      openerp_id: data.id,
      category_id: find_category_id(data),
      size: find_product_size(data),
      default_code: data.default_code,
      x_brokerstaff: data.x_BrokerStaff,
      x_language: data.x_Language
    }
  end

  #Function to extract product code
  def self.find_product_code(data)
    code_array = data.default_code.split("-")
    code_array.delete(code_array.first)
    code_array.delete(code_array.last)
    code_array.join("-")
  end

  #Function to extract product size 
  def self.find_product_size(data)
    data.default_code.split("-").last
  end

  #Function to find the category id using input data rfrom Openerp
  def self.find_category_id(data)
    category = Category.where(name: data.categ_id.name)[0]
    category ? category.id : nil
  end

  #Create Temp File
  def self.create_temp_file(path,data)
    File.open(path, 'wb') do|file|
      file.write(Base64.decode64(data.image))
    end
  end

  #Function to upload Image to cloudinary
  def self.save_image(data)
    if data.image
      path = "#{Rails.root}/public/ProductImage#{data.id}"
      create_temp_file(path,data)
    end
  end

  #Function to check if product has image
  def has_image?
    Dir["#{Rails.root}/public/ProductImage#{self.openerp_id}"].size > 0
  end

  #Upload to cloudinary
  def upload_image
    if has_image?
      path = "#{Rails.root}/public/ProductImage#{self.openerp_id}"
      cloudinary_image = Cloudinary::Uploader.upload(path)

      if cloudinary_image
        File.delete(path)
        ProductImage.create(product_id: self.id, 
                            image_url: cloudinary_image["secure_url"],
                            public_id: cloudinary_image["public_id"])
      end
    end
  end

end
