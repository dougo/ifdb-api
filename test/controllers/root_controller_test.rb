require 'test_helper'

class RootControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes RootController, JSONAPI::ActsAsResourceController
  end

  test 'routes' do
    assert_routing root_path, controller: 'root', action: 'index'
  end

  test 'index verifies accept header' do
    get root_path, as: :json
    assert_response :not_acceptable
  end

  test 'index has links and no data' do
    get root_path, as: :jsonapi
    assert_response :success, json = response.parsed_body
    assert_equal 'application/vnd.api+json', response.content_type
    assert_valid_json JSON::Validator.schema_for_uri('http://jsonapi.org/schema#').schema, json
    refute_includes json, :data
    assert_includes json, :meta
    assert_includes json[:meta], :message
    assert_includes json, :links
    links = json[:links]
    assert_equal({ self: root_url,
                   games: games_url, 
                   members: members_url,
                   clubs: clubs_url
                 }, links)
  end
end
