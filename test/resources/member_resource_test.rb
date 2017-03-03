require 'test_helper'

class MemberResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  EXPECTED_ATTRS = %i(name gender location publicemail profile picture created)

  test 'model_name' do
    assert_equal :User, MemberResource._model_name
  end

  private

  def model_name
    'User'
  end
end
