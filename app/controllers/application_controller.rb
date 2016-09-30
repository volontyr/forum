class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionHelper

  before_filter :is_authenticated

  private 
    def is_authenticated
      redirect_to login_path unless logged_in? 		
    end	

end