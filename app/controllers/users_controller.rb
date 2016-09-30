class UsersController < ApplicationController

  skip_before_filter :is_authenticated, :only => [:new, :create, :confirm_email]

  def show
  	@user = User.find(params[:id])
  end	

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      # log_in @user
      flash[:success] = 'You are successfully registered. Please confirm your email'
      # if !logged_in?
      #   flash[:danger] = 'Your account has not been activated yet'
      # end
  	  redirect_to root_url
  	else
      flash[:error] = "Something went wrong"
  	  render 'new'
  	end  	
  end

  def destroy
    log_out 
    User.destroy(params[:id])
    session.delete(:user_id)
    redirect_to root_url
  end	

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome #{user.name}! Your email has been confirmed.
      Please sign in to continue."
    else
      flash[:danger] = "User does not exist"
    end
    redirect_to login_url  
  end  

  private
  	def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)	
  	end	

end
