require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'JSONAPI' do
    assert_includes UsersController, JSONAPI::ActsAsResourceController
  end

  test 'routes' do
    assert_routing users_path, controller: 'users', action: 'index'
    assert_routing user_path('xyzzy'), controller: 'users', action: 'show', id: 'xyzzy'
  end
end
