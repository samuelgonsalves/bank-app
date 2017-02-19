class AdminController < ApplicationController

  	def index
		@admin = Admin.find(2)
	end

	def home
		@admin = Admin.find(2)
	end

	def manage_admins
		@admin = Admin.find(2)
	end

	def manage_users
		@admin = Admin.find(2)
	end

	def view_users
		@users = User.all
	end

	def destroy
	   	@user = User.find(params[:id])
	    	@user.destroy

	    	respond_to do |format|
	      		format.html { redirect_to admins_url }
	      		format.json { head :no_content }
	    	end
	end

	def manage_accounts
		@admin = Admin.find(2)
	end

end
