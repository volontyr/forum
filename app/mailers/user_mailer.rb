class UserMailer < ApplicationMailer
  default :from => "alex.volontyr@gmail.com"	

  def registration_confirmation(user)
  	@user = user
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Registration  confirmation")
  end	

  def password_reset(user)
  	@user = user
  	mail(:to => "#{user.name} <#{user.email}>", :subject => "Password reset")
  end

end
