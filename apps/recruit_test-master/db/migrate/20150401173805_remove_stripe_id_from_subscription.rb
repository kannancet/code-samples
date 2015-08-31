class RemoveStripeIdFromSubscription < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :stripe_id
    remove_column :subscriptions, :last_four
    remove_column :subscriptions, :coupon_id
    remove_column :subscriptions, :card_type
    remove_column :subscriptions, :current_price
  end
end
