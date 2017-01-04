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
    assert_valid_json HAL::GameSchema.new, resource
    assert_equal 'xyzzy', resource[:id]
    assert_equal 'Adventure', resource[:title]
    assert_equal 'ADVENTURE', resource[:sort_title]
    assert_equal 'Will Crowther', resource[:author]
    assert_equal 'CROWTHER, WILL', resource[:sort_author]
    assert_equal game_path(@model), resource[:_links][:self][:href]
    assert_equal user_path(@model.author_id), resource[:_links][:author][:href]
  end
end
