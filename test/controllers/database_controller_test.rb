require 'test_helper'

class DatabaseControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes DatabaseController, JSONAPI::ActsAsResourceController
  end

  test 'response document has top-level links' do
    get root_path, as: :jsonapi
    doc = response.parsed_body
    assert_equal({ self: root_url,
                   games: games_url, 
                   members: members_url,
                   clubs: clubs_url
                 }, doc[:links])
  end
end
