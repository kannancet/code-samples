module ApplicationHelper

	def subscribe_text
		user_signed_in? ? "Subscribe" : "Sign In"
	end

	def upgrade_text
		user_signed_in? ? 'Start Trial' : "Upgrade Plan"
	end
end
