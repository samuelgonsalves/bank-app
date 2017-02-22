module ApplicationHelper

	$admin_reverse_status = {:approved => '1', :declined => '2', :pending => '3'}
	$admin_status = {1 => :approved, 2 => :declined, 3 => :pending}
	$user_reverse_status = {:approved => '1', :declined => '2', :pending => '3'}	
	$user_status = {1 => :approved, 2 => :declined, 3 => :pending}
	$type = {1 => :withdraw, 2 => :deposit, 3 => :transfer}
	$account_status = {1 => :active, 2 => :closed, 3 => :pending}
	$account_reverse_status = {:active => 1, :closed => 2, :pending => 3}	
	
	
	def full_title(page_title = '')
		base_title = "Bank App"
		if page_title.empty?
			base_title
		else
			page_title + " | " + base_title
		end
	end

	def admin_status_enum(status)
		$admin_status[status]	
	end

	def user_status_enum(status)
		$user_status[status]
	end

	def types_enum(type)
		$type[type]
	end

	def account_status_enum(status)
		$account_status[status]
	end

end
