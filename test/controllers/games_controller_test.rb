require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @model = games(:adventure)
  end

  test 'show game' do
    get game_url(@model), as: :json
    assert_response :success
    assert_equal 'application/hal+json', @response.content_type
    resource = JSON.parse(@response.body).deep_symbolize_keys
    assert_valid_json GameSchema.new.schema, resource
    assert_equal @model.id, resource[:id]
    assert_equal 'Adventure', resource[:title]
    assert_equal 'ADVENTURE', resource[:sort_title]
    assert_equal 'Will Crowther', resource[:author]
    assert_equal 'CROWTHER, WILL', resource[:sort_author]
    assert_equal game_path(@model, format: :json), resource[:_links][:self][:href]
  end
end
