class Admin::PollForm < PollForm
  validates :email, presence: true, if: :new_record?

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Poll')
  end
end
