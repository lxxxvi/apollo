class UserMailerPreview < ActionMailer::Preview
  def authentication_token_email
    user = User.order(updated_at: :desc).first
    UserMailer.with(user: user).authentication_token_email
  end
end
