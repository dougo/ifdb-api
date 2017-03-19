require 'test_helper'

class RoutesConfigTest < ActionDispatch::IntegrationTest
  test 'root' do
    assert_routing root_path, controller: 'database', action: 'show'
  end

  test 'games' do
    assert_routing games_path, controller: 'games', action: 'index'
    assert_routing game_path('xyzzy'), controller: 'games', action: 'show', id: 'xyzzy'
  end

  test 'members' do
    assert_routing members_path, controller: 'members', action: 'index'
    assert_routing member_path('xyzzy'), controller: 'members', action: 'show', id: 'xyzzy'
  end

  test 'club_memberships' do
    assert_routing club_memberships_path, controller: 'club_memberships', action: 'index'
    assert_routing club_membership_path('xyz-zy'), controller: 'club_memberships', action: 'show', id: 'xyz-zy'
  end

  test 'clubs' do
    assert_routing clubs_path, controller: 'clubs', action: 'index'
    assert_routing club_path('xyzzy'), controller: 'clubs', action: 'show', id: 'xyzzy'
  end

  test 'schemas' do
    assert_routing schema_path('test_model'), controller: 'schemas', action: 'show', resource: 'test_model'
    assert_routing schema_path('hal/test_model'), controller: 'schemas', action: 'show', resource: 'hal/test_model'
  end
end
