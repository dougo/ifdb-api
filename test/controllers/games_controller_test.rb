require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test 'ApplicationController' do
    assert_kind_of ApplicationController, GamesController.new
  end

  test 'JSONAPI' do
    assert_includes GamesController, JSONAPI::ActsAsResourceController
  end

  test 'routes' do
    assert_routing games_path, controller: 'games', action: 'index'
    assert_routing game_path('xyzzy'), controller: 'games', action: 'show', id: 'xyzzy'
  end

  test 'redirects when a game forward exists' do
    get game_path(:oldid), as: :jsonapi
    assert_response :moved_permanently
    assert_redirected_to game_url(:newid)
  end

  test 'not_found when a game forward does not exist' do
    get game_path(:nosuchgame), as: :jsonapi
    assert_response :not_found
  end
end
