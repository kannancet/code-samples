require "rails_helper"

feature "Subscription" do 

	scenario "visitor click Buy Now", :js => true do
		visit "/plans"
		find(:css, "#plan_4").click
		expect(page).to have_content "You need to sign in or sign up before continuing"
	end
	
end