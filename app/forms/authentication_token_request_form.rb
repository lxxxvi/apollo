class AuthenticationTokenRequestForm
  include ActiveModel::Model

  attr_reader :email

  validates :email, presence: true

  def initialize(params = {})
    @email = params[:email]
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'AuthenticationTokenRequest')
  end
end
