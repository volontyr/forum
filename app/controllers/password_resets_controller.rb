class PasswordResetsController < ApplicationController
  skip_before_filter :is_authenticated
  
  def new
  	
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user
  	redirect_to root_url
  end

  def edit
  	@user = User.find_by_password_reset_token!(params[:id])
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:id])
  	if @user.password_reset_sent_at < 2.hours.ago
  	  redirect_to new_password_reser_path
	elsif @user.update_attributes(params.require(:user).permit(:password, :password_confirmation))
	  redirect_to root_url
  	else
  	  render :edit
  	end   	
  end
end
