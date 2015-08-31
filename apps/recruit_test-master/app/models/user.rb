class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :messages
	has_one :subscription

	validates_presence_of :email

	#Remove deactivated subscriptions above 24 hours.
	def clean_subscriptions
	  if @subscription = self.subscription
	  	unless @subscription.active?
	  	  recatch_time = ((Time.now - @subscription.deactivated_at) / 1.hour).round
	  	  if recatch_time > 24 
	  	  	@subscription.remove
	  	  end
	  	end
	  end
	end
end
