require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @model = games(:adventure)
  end

  test 'show game' do
    assert_raises(ActiveRecord::RecordNotFound) { get game_path(0), as: :json }

    get game_path(@model), as: :json
    assert_response :success
    assert_equal 'application/hal+json', response.content_type
    resource = response.parsed_body
    assert_valid_json GameSchema.new, resource
    assert_equal @model.id, resource[:id]
    assert_equal 'Adventure', resource[:title]
    assert_equal 'ADVENTURE', resource[:sort_title]
    assert_equal 'Will Crowther', resource[:author]
    assert_equal 'CROWTHER, WILL', resource[:sort_author]
    assert_equal "/games/#{@model.id}", resource[:_links][:self][:href]
  end
end
