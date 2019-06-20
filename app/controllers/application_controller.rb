class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  before_action :authorize
  private

  def current_user
    @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
  end
  def authorize
    unless current_user
      redirect_to :login
      false
    end
  end
end
