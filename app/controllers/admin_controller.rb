class AdminController < ApplicationController
  
  skip_before_filter :is_authenticated
  before_filter :is_auth_admin, :except => [:index, :create]		

  def index
  	redirect_to 'edit' if logged_in?  	
  end

  def create
  	user = User.where(role: "admin").find_by(name: params[:admin][:name])
  	if user && user.authenticate(params[:admin][:password])		
  	  log_in user
  	  remember user
  	  redirect_to '/admin/edit'
  	else
  	  flash[:danger] = 'Invalid name or password'	 
  	  render 'index'
    end	  	
  end

  def edit
  	@user = User.find(session[:user_id])
  	@moderators = User.where(role: "moderator")
  end

  def destroy
  	log_out
  	redirect_to admin_url
  end	

  def user_update
  	user = User.find(params[:id])
  	is_activated = user.activated
  	message = (is_activated) ? 'disactivated' : 'activated'
  	if user.update_attribute(:activated, !is_activated)
  	  flash[:success] = 'User %{name} is %{msg}' % { name: user.name, msg: message }
  	else
  	  flash[:danger] = 'Some error has accured'	
  	end 
  	redirect_to '/admin/edit' 
  end

  private
  	def is_auth_admin
  	  redirect_to admin_path unless logged_in? && is_admin?	
  	end	

end
