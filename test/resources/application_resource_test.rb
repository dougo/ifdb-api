require 'test_helper'

class ApplicationResourceTest < ActiveSupport::TestCase
  test 'is a JSONAPI::Resource' do
    assert_equal JSONAPI::Resource, ApplicationResource.superclass
  end

  class TestModel
    def id; :xyzzy end
    def foo; nil end
    def bar; 42 end
  end

  class TestResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar
  end

  test 'omits nil attributes' do
    resource = TestResource.new(TestModel.new, {})
    assert_equal [:id, :bar], resource.fetchable_fields
  end

  test 'custom links' do
    resource = TestResource.new(TestModel.new, {})
    serializer = OpenStruct.new(link_builder: OpenStruct.new(base_url: 'http://example.com'))
    links = resource.custom_links(serializer: serializer)
    url = URI.parse(links[:describedby])
    assert_predicate url, :absolute?
    assert_equal 'example.com', url.host
    assert_equal Rails.application.routes.url_helpers.schema_path('test'), url.path
  end

  test 'sort by creation time by default' do
    assert_equal [{ field: 'created', direction: :desc }], TestResource.default_sort
  end
end
