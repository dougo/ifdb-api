require 'test_helper'

class ClubsControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes ClubsController, JSONAPI::ActsAsResourceController
  end

  test 'routes' do
    assert_routing clubs_path, controller: 'clubs', action: 'index'
    assert_routing club_path('xyzzy'), controller: 'clubs', action: 'show', id: 'xyzzy'
  end
end
