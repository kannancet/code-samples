class Store < ActiveRecord::Base
  
  belongs_to :company
  has_many :store_customer_groups, dependent: :destroy
  has_many :customer_groups, :through => :store_customer_groups, dependent: :destroy
  has_many :customers, :through => :customer_groups
  
  has_many :store_languages
  has_many :languages, :through => :store_languages
  has_many :store_images, :through => :store_languages
  
  has_many :pages
  
  has_many :store_currencies
  has_many :currencies, :through => :store_currencies
  
  has_many :site_administrators
  
  has_many :store_contact_numbers
  has_many :store_contact_emails

  has_many :store_roles, dependent: :destroy
  has_many :roles, through: :store_roles, dependent: :destroy 

  has_many :store_category_positions
  has_many :categories, through: :store_category_positions 

  has_many :store_administrators
  
  has_attached_file :display_logo, :styles => { :xlarge => "320x320>", :large => "160x160>", :medium => "100x100>", :small => "40x40>", :thumb => "20x20>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :display_logo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  has_attached_file :return_policy_pdf
  #validates_attachment_content_type :return_policy_pdf, :content_type => ["application/pdf"]

  has_many :store_administrators

  #Fetch all admin emails - Store admin + Site admin.
  def admin_emails
    store_admins = store_administrators.collect(&:email)
    system_admins = SystemAdmin.all.collect(&:email)
    store_admins + system_admins
  end

  #Function to check if store has public registration
  def has_public_signup?
    abbreviation != "FN"
  end

  #Function to find the new arrivals in a store.
  def new_arrivals(user)
    role_id = user.store_role.role.id
    Product.includes(:product_images).joins(store_roles: [:store, :role]).where("stores.id = ? AND roles.id = ?", id, role_id).last(9)
  end

  #Function to find the new arrivals in a store.
  def featured_products(user, page=1)
    role_id = user.store_role.role.id
    Product.includes(:product_images).joins(store_roles: [:store, :role]).page(page).per(12).where("stores.id = ? AND roles.id = ?", id, role_id)
  end

  #Function to get all products
  def products(page = 1)
    Product.includes(:product_images).joins(store_roles: [:store, :role]).page(page).where("stores.id = ?", id)
  end

  def num_customers
    self.customers.count
  end
  
  def num_customer_groups
    self.customer_groups.count
  end
  
  def num_languages
    self.languages.count
  end
  
  def store_url
    return "http://#{self.subdomain}.plainandsimpleapp.com"
  end

  def uniq_roles
    store_roles = StoreRole.where(store_id: id).pluck(:store_id, :role_id).uniq
    store_roles.collect do |str| 
      store_role = StoreRole.where(store_id: str[0], role_id: str[1])[0]
      OpenStruct.new(role_name: store_role.role.name, store_role_id: store_role.id )
    end 
  end

  # to find all categories
  def categories_by_position
    Category.joins(:store_category_positions => :store).order("store_category_positions.position ASC").where("stores.id = ?", self.id)
  end

  # to update positions of categories
  def update_category_positions(category_ids)
    unless category_ids.blank?
      category_ids.compact!
      category_ids.each_with_index do |category_id, index|
        store_category_position = StoreCategoryPosition.find_or_create_by(category_id: category_id.to_i, store_id: self.id)
        store_category_position.position = index + 1
        store_category_position.save
      end
    end
  end

  # to update roles of a store.
  def update_roles(role_names)
    role_names.map { |name| self.roles.find_or_create_by(name: name) } if role_names
    @roles = self.roles.where.not(name: role_names)
    @roles.destroy_all if @roles
  end

end
