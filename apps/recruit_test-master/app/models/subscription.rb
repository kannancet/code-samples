class Subscription < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :plan

  #Function to check if subscription is active or inactive
  def active?
  	deactivation_status.blank? 
  end

  #Function to reactivate subscription
  def reactivate(flash)
  	recatch_time = ((Time.now - self.deactivated_at) / 3600).round
  	
  	if recatch_time <= 24 
  	  flash[:notice] = "Successfully activated your subscription"
      self.update(deactivation_status: false, deactivated_at: false)
    else
      self.destroy
      flash[:alert] = "Sorry! You cannot reactivate your account after 24 hours."
    end
  end

  #function to deactivate subscription
  def deactivate(flash)
  	flash[:notice] = "Successfully deactivated your subscription"
	  update(deactivation_status: true, deactivated_at: Time.now)
  end

  #Function delete subscription for ever
  def remove
    customer = Stripe::Customer.retrieve(self.stripe_customer_id)
	  customer.delete()
	  self.destroy
  end

  #Function to create subscription
  def self.add(stripe_params, current_user)
	  customer = Stripe::Customer.create(
	    :email => stripe_params[:email],
	    :card  => stripe_params[:token],
	    :plan => stripe_params[:stripe_plan]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => stripe_params[:amount],
	    :description => stripe_params[:desc],
	    :currency    => stripe_params[:currency]
	  )

	  if customer && charge
	  	new_subscription = Subscription.create(stripe_card_id: stripe_params[:card],
											                       stripe_customer_id: customer.id,
											                       stripe_charge_id: charge.id,
											                       stripe_payment_email: stripe_params[:email],
											  		                 user_id: current_user.id,
											  		                 plan_id: stripe_params[:target_plan].to_i
											  		                )
	    @flash = {result: "success", msg: "You have successfully subscribed."}
	    return @flash
	  end
  end

end
