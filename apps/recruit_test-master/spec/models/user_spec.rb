require 'rails_helper'
require 'stripe_mock'
RSpec.describe User, :type => :model do

  describe 'Create a new User' do

  	it 'Should increase user count by one.' do
      expect { create(:user) }.to change { User.count }.from(0).to(1)
    end

    it 'Should be a valid default user' do
      @user = create(:user)

      expect(@user.respond_to?(:email)).to eq true
      expect(@user.respond_to?(:name)).to eq true
      expect(@user.email).to eq "defaultuser@gmail.com"
      expect(@user.name).to eq "Default User"
    end

    it 'Should have no messages and subscriptions' do
      @user = create(:user)

      expect(@user.messages.size).to eq 0
      expect(@user.subscription).to eq nil
    end

  end

  describe 'Clean Subscriptions' do
     let(:stripe_helper) { StripeMock.create_test_helper }
     before { StripeMock.start }
     after { StripeMock.stop }
     before do
		  	@user = create(:user)
		  	@plan = create(:plan)

		    @customer = Stripe::Customer.create({
		      email: 'defaultuser@gmail.com',
		      card: stripe_helper.generate_card_token
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
                                stripe_card_id: stripe_helper.generate_card_token,
                                stripe_customer_id: @customer.id,
                                stripe_charge_id: @charge.id,
                                stripe_payment_email: @customer.email)
     end


  	it 'Creates a valid subscription' do

	    expect(@customer.email).to eq('defaultuser@gmail.com')
	    expect(@user.subscription).to eq @subscription
	    expect(@subscription.plan).to eq @plan
    end

    it "Deactivates a subscription" do

    	expect { 
    		@subscription.update(deactivation_status: true, deactivated_at: Time.now)
    	}.to change { @subscription.active? }.from(true).to(false)
    end

    it 'Cleans  Deactivated Subscriptions and older than 24 hours' do

    	@subscription.update(deactivation_status: true, deactivated_at: Time.now - 26.hours)
    	expect { @user.clean_subscriptions }.to change { Subscription.count }.from(1).to(0)
    end

    it 'Donot Clean Deactivated Subscription and not older than 24 hours' do

    	@subscription.update!(deactivation_status: true, deactivated_at: Time.now - 22.hours)
    	expect { @user.clean_subscriptions }.not_to change { @user.subscription }.from( @subscription )
    	expect { @user.clean_subscriptions }.not_to change { Subscription.count }.from(1)
    end

  end

end
