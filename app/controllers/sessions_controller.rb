class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    if view_context.user_login(params[:name], params[:password])
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid login"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, notice: "Logged out."
  end
end
