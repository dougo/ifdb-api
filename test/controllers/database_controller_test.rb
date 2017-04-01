require 'test_helper'

class DatabaseControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationResourceController

  test 'resource_serializer_klass' do
    get root_path
    assert_equal 'http://www.example.com', response.parsed_body[:data][:links][:self]
  end
end
