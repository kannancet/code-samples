module SubscriptionsHelper

  #Function to create subscription plan colors
  def plan_color(plan)
  	if current_user && current_user.subscription && (plan.id == current_user.subscription.plan_id)
  		[["panel-white", "btn-danger"], ["panel-white", "btn-danger"], ["panel-white", "btn-danger"]]
  	else
  	  [["panel-red", "btn-danger"], ["panel-blue", "btn-info"], ["panel-green", "btn-success"]]
  	end
  end

  #Function to show correct plan href
  def plan_href_text(plan)
  	if current_user 

  	  if subscription = current_user.subscription 

  	  	if (plan.id == subscription.plan_id)
  	      {text: "UNSUBSCRIBE", href: destroy_subscription_path(subscription)}
  	    else
  	       {text: "UPGRADE!", href: upgrade_subscription_path(plan)}
  	    end
  	  else
  	  	 {text: "BUY NOW!", href: new_subscription_path(plan)}
  	  end
  	else
  	  {text: "BUY NOW!", href: new_subscription_path(plan)}
  	end		
  end

  #Function to put activation reactivation button
  def activation_href_text(subscription)
  	plan = subscription.plan
  	if subscription.active? 
  	  {text: "DEACTIVATE", color: "btn-warning", href: deactivate_subscription_path(subscription)}
  	else
  	  {text: "ACTIVATE", color: "btn-success", href: reactivate_subscription_path(subscription)}
  	end
  end

end
