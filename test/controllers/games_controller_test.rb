require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationResourceController

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
