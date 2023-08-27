class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = AccessToken.create!(user: user).token

      { success: true, token: token }
    else
      { errors: 'Invalid email or password', success: false }
    end
  end

  def destroy
    AccessToken.find_by!(token: params[:token]).destroy!

    { success: true }
  end
end
