class Api::SubscriptionsController < Api::BaseController
  protect_from_forgery with: :null_session



  #Function for currency conversion
  def convert_currency
  	to = currency_params[:target_currency].upcase
  	@plan = Plan.find(currency_params[:target_plan])
  	@amount = $openexchange.convert(@plan.price, :from => "USD", :to => to)
  end

  #Function to create subscriptions
  def create
  	begin
  	  @flash = Subscription.add(stripe_params, current_user)	
	rescue Stripe::CardError => e
	  @flash = {result: "fail", msg: e.message}
	end	
  end

  private

  def subscription_params
    #params_filtered = params.require(:user).permit(:name, :gender, :country, :birth_date)
  end

  def query_params
    #params.permit(:name, :gender, :country, :birth_date)
  end	

  def currency_params
  	params.require(:currency_params).permit(:target_currency, :target_plan)
  end

  def stripe_params
  	params.require(:stripe_params).permit(:token, :amount, :email, :desc, :target_plan, :currency, :stripe_plan, :card)
  end
end
