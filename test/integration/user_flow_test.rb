require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
	
	test "user flow should redirect user to '/' and admin to '/admins/home' after login" do

		# login with admin ID, password => should redirect to admins home page
	    	get '/login'
		assert_equal 200, status

		post '/login', params: {session: {email: admins(:admin_user).user.email, password: 'admin123'}}
		assert_redirected_to "/admins/home?id=#{admins(:admin_user).id}", 'admin after login not redirected to /admins/home'

		delete '/logout'
		follow_redirect!
		assert_equal '/login', path

		# login as a user, it should redirect the user to users home page
		post '/login', params: {session: {email: users(:user1).email, password: 'user123'}}
		assert_redirected_to '/'
		
	end

	test "user should not be able to access admins pages" do
		post '/login', params: {session: {email: users(:user1).email, password: 'user123'}}
		assert_redirected_to '/'

		get '/admins/manage_accounts'
		assert_redirected_to '/'

		delete '/logout'
	end

end
