require 'test_helper'

class TestModel; end
class TestModelSchema
  def as_json
    { type: :object }
  end
end

class SchemasControllerTest < ActionDispatch::IntegrationTest
  test 'show schema' do
    get schema_path(:test_model), as: :json
    assert_response :success
    resource = response.parsed_body
    assert_equal 'object', resource[:type]
    assert_equal schema_url(:test_model), resource[:id]
  end
end
