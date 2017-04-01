require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes GamesController, JSONAPI::ActsAsResourceController
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

  test 'resource_serializer_klass' do
    get game_path(games(:maximal))
    assert_equal({ count: 3 }, response.parsed_body[:data][:relationships][:ratings][:links][:related][:meta])
  end
end
