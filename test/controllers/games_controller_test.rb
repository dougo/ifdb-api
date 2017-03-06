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
end
