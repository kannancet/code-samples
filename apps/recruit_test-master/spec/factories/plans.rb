FactoryGirl.define do
  factory :plan do
	  name 'Personal'
	  price 10.00
	  interval 'month'
	  stripe_id 1
	  features ['1 Project', '1 Page', '1 User', '1 Organization'].join("\n\n")
	  display_order 1
  end

end
