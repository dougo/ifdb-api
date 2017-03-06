require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  test 'ApplicationController' do
    assert_kind_of ApplicationController, MembersController.new
  end

  test 'JSONAPI' do
    assert_includes MembersController, JSONAPI::ActsAsResourceController
  end

  test 'routes' do
    assert_routing members_path, controller: 'members', action: 'index'
    assert_routing member_path('xyzzy'), controller: 'members', action: 'show', id: 'xyzzy'
  end
end
