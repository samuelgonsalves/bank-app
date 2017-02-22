class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_filter :set_enums
  def set_enums
    @type = {:withdraw => 1, :deposit => 2, :transfer => 3}
    @status = {:approved => 1, :declined => 2, :pending => 3}
    @status_name = {1 => "Approved", 2 => "Declined", 3 => "Pending"}
    @type_name = {1 => "Withdraw", 2 => "Deposit", 3 => "Transfer"}
  end

  protected
  def authenticate_user!
    if logged_in?
      return
    else
      redirect_to login_path #, :notice => 'if you want to add a notice'
      ## if you want render 404 page
      ##render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
end
