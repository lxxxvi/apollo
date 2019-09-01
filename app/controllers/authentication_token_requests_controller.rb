class AuthenticationTokenRequestsController < ApplicationController
  def new
    @form = AuthenticationTokenRequestForm.new
  end

  def create
    @form = AuthenticationTokenRequestForm.new(authentication_token_request_params)

    if @form.valid?
      user = User.find_by(email: @form.email)

      if user.present?
        user.refresh_authentication_token!
        UserMailer.with(user: user).authentication_token_email.deliver_later
      end

      flash.now[:notice] = 'Please find the token in the email that we have just sent you'
    end

    render :new
  end

  private

  def authentication_token_request_params
    params.require(:authentication_token_request).permit(:email)
  end
end
