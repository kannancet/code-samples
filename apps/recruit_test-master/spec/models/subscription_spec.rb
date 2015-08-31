require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  
  describe "Subscription method" do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

  	before do
	  	@user = create(:user)
	  	@plan = create(:plan)

	  	card = stripe_helper.generate_card_token
	    @customer = Stripe::Customer.create({
	      email: 'defaultuser@gmail.com',
	      card: card
	    })

	    @charge = Stripe::Charge.create(
	      :customer    => @customer.id,
	      :amount      => @plan.price.to_i,
	      :description => @plan.name,
	      :currency    => "usd"
	    )

		  @subscription = create(:subscription, user: @user, plan: @plan, 
	                        deactivation_status: nil, 
	                        deactivated_at: nil,
	                        stripe_card_id: card,
	                        stripe_customer_id: @customer.id,
	                        stripe_charge_id: @charge.id,
	                        stripe_payment_email: @customer.email) 		
  	end

  	it "to checks if a subscription is active" do
  	  expect(@subscription.active?).to eq true
    end

    it "to Deactive a subscription" do
      expect {@subscription.deactivate({})}.to change {@subscription.active?}.from(true).to(false)
    end

    it "to Reactive a subscription" do
      @subscription.deactivate({})
      expect {@subscription.reactivate({})}.to change {@subscription.active?}.from(false).to(true)
    end


    it "to Remove a subscription" do
      expect {@subscription.remove}.to change{Subscription.count}.from(1).to(0)
    end

  end
end
