require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @model = users(:molydeux)
  end

  test 'show user' do
    assert_raises(ActiveRecord::RecordNotFound) { get user_path(0), as: :json }

    get user_path(@model), as: :json
    assert_response :success
    assert_equal 'application/hal+json', response.content_type
    resource = response.parsed_body
    assert_valid_json UserSchema.new, resource
    assert_equal @model.id, resource[:id]
    assert_equal 'Peter Molydeux', resource[:name]
    assert_equal "/users/#{@model.id}", resource[:_links][:self][:href]
  end
end
