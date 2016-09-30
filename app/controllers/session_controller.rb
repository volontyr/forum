class SessionController < ApplicationController
  
  skip_before_filter :is_authenticated, :only => [:new, :create]	

  def new
    log_out if logged_in?
  end

  def create
  	user = User.where(email: params[:session][:email].downcase).first
  	if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
  	    log_in user
        if logged_in?
  	      remember user
        else 
          flash[:dnager] = 'Your account has not been activated yet'
        end   
  	    redirect_to user
      else
        flash.now[:danger] = 'Please activate your account by following the 
        instructions in the account confirmation email you received to proceed'
        render 'new'
      end  
  	else
  	  flash[:danger] = 'Invalid email or password'
  	  render 'new'	
  	end	
  end

  def destroy
  	log_out
  	redirect_to root_url
  end	

end
