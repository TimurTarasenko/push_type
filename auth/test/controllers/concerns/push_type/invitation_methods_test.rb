require 'test_helper'

module PushType
  class InvitationMethodsTest < ActiveSupport::TestCase

    subject { PushType::UsersController.new }

    it { subject.methods.include?(:invite).must_equal true }

  end
end
