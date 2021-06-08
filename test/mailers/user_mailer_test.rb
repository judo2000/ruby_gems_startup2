require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def new_user
    UserMailer.new_user(User.first).deliver_now
  end
end
