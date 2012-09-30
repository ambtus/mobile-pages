class SessionsController < ApplicationController
  skip_before_filter :authorize

  def login
    render :new
  end

  def create
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      cookies.permanent[:auth_token] = user.auth_token
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid name or password"
      render :new
    end
  end

end
