require 'test_helper'

class FetchTest < ActionDispatch::IntegrationTest
  # TODO: DRY this up a bit

  test 'fetch game and game schema' do
    @model = games(:adventure)
    get game_path(@model), as: :jsonapi
    assert_response :success
    assert_equal 'application/vnd.api+json', response.content_type
    resource = response.parsed_body[:data]
    req_url = request.url

    get resource[:links][:describedby], as: :json
    assert_response :success
    schema = response.parsed_body

    assert_valid_json schema, resource
    assert_equal 'xyzzy', resource[:id]
    assert_equal 'Adventure', resource[:attributes][:title]
    assert_equal 'Will Crowther', resource[:attributes][:author]
    assert_equal req_url, resource[:links][:self]
    # TODO: author relationship
    # assert_equal user_path(@model.author_id), resource[:_links][:author][:href]
  end

  test 'fetch games by page' do
    get games_path, as: :jsonapi
    assert_response :success
    page1 = response.parsed_body
    resources = page1[:data]
    assert_equal 10, resources.size

    get page1[:links][:next], as: :jsonapi
    assert_response :success
    page2 = response.parsed_body
    assert_includes page2[:links], :prev
  end

  test 'fetch user and user schema' do
    @model = users(:maximal)
    get user_path(@model), as: :jsonapi
    assert_response :success
    assert_equal 'application/vnd.api+json', response.content_type
    resource = response.parsed_body[:data]
    req_url = request.url

    get resource[:links][:describedby], as: :json
    assert_response :success
    schema = response.parsed_body

    assert_valid_json schema, resource
    assert_equal @model.id, resource[:id]
    assert_equal 'Peter Molydeux', resource[:attributes][:name]
    assert_equal req_url, resource[:links][:self]
  end

  test 'fetch user not found' do
    get user_path(0), as: :jsonapi
    assert_response :not_found
    assert_equal 'application/vnd.api+json', response.content_type
    resource = response.parsed_body
    assert_valid_json 'http://jsonapi.org/schema', resource
    assert_equal '404', resource[:errors][0][:status]
    assert_equal 'Record not found', resource[:errors][0][:title]
  end

  test 'fetch users by page' do
    get users_path, as: :jsonapi
    assert_response :success
    page1 = response.parsed_body
    resources = page1[:data]
    assert_equal 10, resources.size

    get page1[:links][:next], as: :jsonapi
    assert_response :success
    page2 = response.parsed_body
    assert_includes page2[:links], :prev
  end
end
