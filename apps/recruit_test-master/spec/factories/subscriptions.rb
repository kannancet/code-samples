FactoryGirl.define do
  factory :subscription do
    plan_id 1
	user_id 1
	deactivation_status nil
	deactivated_at nil
	stripe_card_id ""
	stripe_customer_id ""
	stripe_charge_id ""
	stripe_payment_email "defaultuser@gmail.com"
	created_at Time.now
	updated_at Time.now
  end

end
