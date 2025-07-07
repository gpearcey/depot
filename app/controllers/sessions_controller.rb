class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    elsif User.count.zero?
      # If no users exist, allow any login to create the first admin user
      user = User.create!(
        name: params[:email_address],
        email_address: params[:email_address],
        password: params[:password],
        password_confirmation: params[:password]
      )
      start_new_session_for user
      redirect_to after_authentication_url, notice: "First administrator created."
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
