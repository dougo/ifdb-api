require 'test_helper'

class TestModel; end
class TestModelSchema
  def schema
    { type: :object }
  end
end

class SchemasControllerTest < ActionDispatch::IntegrationTest
  test 'show schema' do
    get schema_path(:test_model), as: :json
    assert_response :success
    resource = JSON.parse(@response.body).deep_symbolize_keys
    assert_equal 'object', resource[:type]
    assert_equal schema_url(:test_model), resource[:id]
  end
end
