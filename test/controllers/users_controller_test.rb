require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'JSONAPI' do
    assert_includes UsersController, JSONAPI::ActsAsResourceController
  end
end
