require 'test_helper'

class ClubMembershipsControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes ClubMembershipsController, JSONAPI::ActsAsResourceController
  end

  test 'routes' do
    assert_routing club_memberships_path, controller: 'club_memberships', action: 'index'
    assert_routing club_membership_path('xyz-zy'), controller: 'club_memberships', action: 'show', id: 'xyz-zy'
  end
end
