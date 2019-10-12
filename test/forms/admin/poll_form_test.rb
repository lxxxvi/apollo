require 'test_helper'

class Admin::PollFormTest < ActiveSupport::TestCase
  test 'invalid form' do
    poll = polls(:best_actor_published)
    form = Admin::PollForm.new(poll, title: '', description: '')

    assert_not form.valid?
    assert_includes form.errors.keys, :title
    assert_includes form.errors.keys, :description
  end

  test 'valid form' do
    poll = polls(:best_actor_published)
    form = Admin::PollForm.new(poll, title: 'Title', description: 'Description')

    assert form.valid?
  end

  test 'not valid when started' do
    poll = polls(:best_singer_started)
    form = Admin::PollForm.new(poll)

    assert_not form.valid?
    assert_includes form.errors.keys, :base
  end
end
