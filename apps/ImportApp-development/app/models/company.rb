class Company < ActiveRecord::Base

  has_many :operations
  paginates_per 10

  validates_presence_of :name
  default_scope { includes(:operations) }

  include Statistics
end
