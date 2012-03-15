class ApplicationController < ActionController::Base
  http_basic_authenticate_with :name => MobilePages::Application.config.http_name, :password => MobilePages::Application.config.http_password
  protect_from_forgery
  layout 'application'
end
