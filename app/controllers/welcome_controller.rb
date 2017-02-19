class WelcomeController < ApplicationController
	before_action :authenticate_user!
	
	def home
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering Bank App Home Page")
		@user = current_user
		@user
	end
end