class AddCharIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_card_id, :string
    add_column :subscriptions, :stripe_customer_id, :string
    add_column :subscriptions, :stripe_charge_id, :string
    add_column :subscriptions, :stripe_payment_email, :string
  end
end
