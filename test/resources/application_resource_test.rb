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

  class TestModelResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar
  end

  test 'omits nil attributes' do
    resource = TestModelResource.new(TestModel.new, {})
    assert_equal [:id, :bar], resource.fetchable_fields
  end
end
