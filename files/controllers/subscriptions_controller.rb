class SubscriptionsController < ApplicationController

	before_filter :set_plan, only: [:new, :create, :upgrade]
	before_filter :authenticate_user!, except: :plans

	#Function to create subscription
	def plans
	  @plans = Plan.all
	  current_user.clean_subscriptions if current_user
	end

	#Function for new subscription form
	def new	
	  @currencies = CURRENCIES	
	end

	#Function for upgrade subscription
	def upgrade
	  @plan = Plan.find(params[:id])
	  @subscription.remove if @subscription = current_user.subscription 

	  redirect_to new_subscription_path(@plan) 	
	end

	#Function for destroy subscription
	def destroy
	  @subscription = Subscription.find(params[:id])
	  @subscription.remove if @subscription

	  redirect_to plans_path	  	
	end

	#Function for reactivate subscription
	def reactivate
	  @subscription = Subscription.find(params[:id])
	  (@subscription.reactivate(flash) unless @subscription.active?) if @subscription

	  redirect_to plans_path	  	
	end

	#Function for deactivate subscription
	def deactivate
	  @subscription = Subscription.find(params[:id])
	  (@subscription.deactivate(flash) if @subscription.active?) if @subscription

	  redirect_to plans_path
	end


	private

	#Fucntion to set the plan from Id.
	def set_plan
		@plan = Plan.find(params[:id])
	end

end
