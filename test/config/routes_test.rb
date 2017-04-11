require 'test_helper'

class RoutesConfigTest < ActionDispatch::IntegrationTest
  test 'root' do
    assert_routing root_path, controller: 'database', action: 'show'
  end

  # TODO: make a test_jsonapi_resource_routing helper

  test 'games' do
    assert_routing games_path, controller: 'games', action: 'index'
    assert_routing game_path('xyzzy'), controller: 'games', action: 'show', id: 'xyzzy'
    assert_routing game_relationships_author_profiles_path('xyzzy'), relationship: 'author_profiles',
                   controller: 'games', action: 'show_relationship', game_id: 'xyzzy'
    assert_routing game_author_profiles_path('xyzzy'),               relationship: 'author_profiles',
                   source: 'games', controller: 'members', action: 'get_related_resources', game_id: 'xyzzy'
    assert_routing game_relationships_editor_path('xyzzy'),          relationship: 'editor',
                   controller: 'games', action: 'show_relationship', game_id: 'xyzzy'
    assert_routing game_editor_path('xyzzy'),                        relationship: 'editor',
                   source: 'games', controller: 'members', action: 'get_related_resource', game_id: 'xyzzy'
  end

  test 'reviews' do
    assert_routing review_path('xyzzy'), controller: 'reviews', action: 'show', id: 'xyzzy'
  end

  test 'game_links' do
    assert_routing game_link_path('xyzzy-0'), controller: 'game_links', action: 'show', id: 'xyzzy-0'
  end

  test 'competitions' do
    assert_routing competitions_path, controller: 'competitions', action: 'index'
  end

  test 'members' do
    assert_routing members_path, controller: 'members', action: 'index'
    assert_routing member_path('xyzzy'), controller: 'members', action: 'show', id: 'xyzzy'
  end

  test 'club_memberships' do
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
