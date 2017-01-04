require 'test_helper'

class TestModel; end
class TestModelSchema
  def as_json
    { title: 'Schema for TestModel JSON API resources' }
  end
end

class HAL::TestModelSchema
  def as_json
    { title: 'Schema for TestModel HAL resources' }
  end
end

class SchemasControllerTest < ActionDispatch::IntegrationTest
  test 'routes' do
    assert_routing schema_path('test_model'), controller: 'schemas', action: 'show', resource: 'test_model'
    assert_routing schema_path('hal/test_model'), controller: 'schemas', action: 'show', resource: 'hal/test_model'
  end

  test 'show schema' do
    assert_raises(NameError) { get schema_path(:xyzzy), as: :json }

    get schema_path(:test_model), as: :json
    assert_response :success
    resource = response.parsed_body
    assert_equal 'Schema for TestModel JSON API resources', resource[:title]
    assert_equal schema_url(:test_model), resource[:id]
  end

  test 'show HAL schema' do
    get schema_path('hal/test_model'), as: :json
    assert_response :success
    resource = response.parsed_body
    assert_equal 'Schema for TestModel HAL resources', resource[:title]
    assert_equal schema_url('hal/test_model'), resource[:id]
  end
end
