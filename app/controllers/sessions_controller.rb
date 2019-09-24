class SessionsController < ApplicationController
  def new
    user = User.with_valid_authentication_tokens
               .find_by(authentication_token: params[:authentication_token])

    if user.present?
      sign_in(user)
      user.update!(email_verified_at: Time.zone.now)
      redirect_to root_path, notice: 'Successfully signed in.'
    else
      redirect_to request_token_path, notice: 'Invalid authentication token.'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
