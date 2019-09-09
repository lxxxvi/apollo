class UserMailer < ApplicationMailer
  def authentication_token_email
    @user = params[:user]

    mail(to: @user.email, subject: 'Your Apollo authentication token')
  end
end
