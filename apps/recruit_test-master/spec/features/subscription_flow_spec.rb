require "rails_helper"

feature "Subscription" do 

	scenario "User Sign Up => Subscribe => Stripe Payment", :js => true do
		visit "/users/sign_up"
		fill_in('user_email', :with => 'defaultuser1@gmail.com')
		fill_in('user_password', :with => 'password')
		fill_in('user_password_confirmation', :with => 'password')
		find("input[value='Sign up']").click

		expect(page).to have_content "Welcome! You have signed up successfully."

		visit "/plans"
		find(:css, "#plan_4").click
		expect(page).to have_content "Personal Plan"		

		find(:css, "#make_payment").click

	 stripe_iframe = all('iframe[name=stripe_checkout_app]').last
	  Capybara.within_frame stripe_iframe do
		  page.execute_script(%Q{ $('input#card_number').val('4242 4242 4242 4242'); })
		  page.execute_script(%Q{ $('input#cc-exp').val('01/18'); })
		  page.execute_script(%Q{ $('input#cc-csc').val('123'); })
	    find(:css, "#submitButton").click
	    find(:css, "#plan_4", wait: 30)
	  end		
	end
	
end