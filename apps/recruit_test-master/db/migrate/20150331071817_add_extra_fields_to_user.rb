class AddExtraFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :birth_date, :datetime
    add_column :users, :gender, :string
    add_column :users, :country, :string
  end
end
