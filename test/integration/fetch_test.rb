require 'test_helper'

class FetchTest < ActionDispatch::IntegrationTest
  # TODO: DRY this up a bit

  test 'fetch game and game schema' do
    # TODO: navigate from home page

    @model = games(:maximal)
    get game_path(@model), as: :jsonapi
    assert_response :success, response.parsed_body
    assert_equal 'application/vnd.api+json', response.content_type
    resource = response.parsed_body[:data]
    req_url = request.url

    get resource[:links][:describedby], as: :json
    assert_response :success
    schema = response.parsed_body

    assert_valid_json schema, resource
    assert_equal @model.id, resource[:id]
    assert_match /Max Blaster/, resource[:attributes][:title]
    assert_equal game_url(@model), resource[:links][:self]
    # TODO: author relationship
    # assert_equal member_path(@model.author_id), resource[:_links][:author][:href]

    editor_rel = resource[:relationships][:editor]
    assert_equal 'members',       editor_rel[:data][:type]
    assert_equal @model.editedby, editor_rel[:data][:id]
    # TODO: follow editor relationship link?
  end

  test 'fetch games by page' do
    get root_path, as: :jsonapi
    assert_response :success
    games_link = response.parsed_body[:links][:games]

    get games_link, as: :jsonapi
    assert_response :success
    page1 = response.parsed_body
    resources = page1[:data]
    assert_equal 20, resources.size

    get page1[:links][:next], as: :jsonapi
    assert_response :success
    page2 = response.parsed_body
    assert_includes page2[:links], :prev
  end

  test 'fetch member and member schema' do
    @model = users(:maximal)
    get member_path(@model), as: :jsonapi
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

  test 'fetch member not found' do
    get member_path(0), as: :jsonapi
    assert_response :not_found
    assert_equal 'application/vnd.api+json', response.content_type
    resource = response.parsed_body
    assert_valid_json 'http://jsonapi.org/schema', resource
    assert_equal '404', resource[:errors][0][:status]
    assert_equal 'Record not found', resource[:errors][0][:title]
  end

  test 'fetch members by page' do
    get root_path, as: :jsonapi
    assert_response :success
    members_link = response.parsed_body[:links][:members]

    get members_link, as: :jsonapi
    assert_response :success
    page1 = response.parsed_body
    resources = page1[:data]
    assert_equal 20, resources.size

    get page1[:links][:next], as: :jsonapi
    assert_response :success
    page2 = response.parsed_body
    assert_includes page2[:links], :prev
  end
end
