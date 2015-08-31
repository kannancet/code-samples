FactoryGirl.define do 

	factory :user do 
		email "defaultuser@gmail.com"
		password "defaultuser"
		password_confirmation "defaultuser"
		name "Default User"
	end

end