require 'test_helper'

class ApplicationResourceTest < ActiveSupport::TestCase
  test_extends JSONAPI::Resource

  test 'abstract' do
    assert_predicate self.class.described_type, :_abstract
  end

  test 'includes CompoundID' do
    assert_includes self.class.described_type, CompoundID
  end

  class TestModel
    def id; :xyzzy end
    def foo; nil end
    def bar; 42 end
    def baz; '' end
    def garply_id; :plugh end
    def quux_id; '' end
    def frobs; [1, 2, 3] end
  end

  class TestResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar, :baz
    has_one :garply, class_name: 'Test'
    has_one :quux, class_name: 'Test'
    has_one :vroom, class_name: 'Test', foreign_key_on: :related
    has_many :frobs, class_name: 'Test'

    def self.created_field
      :born_on
    end

    attr_reader :frobs_meta_options

    def garply_includes
      %w(sifl olly)
    end

    def vroom_fields
      { widgets: %w(name count), sprockets: %w(size color) }
    end

    def frobs_meta(options)
      @frobs_meta_options = options
      { count: frobs.size }
    end
  end

  test 'immutable' do
    refute_predicate TestResource, :mutable?
  end

  test 'omits blank attributes but includes all relationships' do
    resource = TestResource.new(TestModel.new, {})
    assert_same_elements %i(id bar garply quux vroom frobs), resource.fetchable_fields
  end

  test 'created_field' do
    assert_equal :created, ApplicationResource.created_field
  end

  test 'sort by creation time by default' do
    assert_equal [{ field: :born_on, direction: :desc }], TestResource.default_sort
  end

  class ApplicationResource::SerializerTest < ActiveSupport::TestCase
    test_extends JSONAPI::ResourceSerializer

    subject { self.class.described_type.new(TestResource, serialization_options: { foo: 42 }) }

    test 'foo related link has include param if foo_includes is defined' do
      resource = TestResource.new(TestModel.new, {})
      link = subject.object_hash(resource)['relationships']['garply']['links']['related']
      assert_equal 'include=sifl%2Colly', URI(link).query
    end

    test 'foo related link has fields params if foo_fields is defined' do
      resource = TestResource.new(TestModel.new, {})
      link = subject.object_hash(resource)['relationships']['vroom']['links']['related']
      assert_equal 'fields%5Bsprockets%5D=size%2Ccolor&fields%5Bwidgets%5D=name%2Ccount', URI(link).query
    end
    
    test 'foo related link includes meta if foo_meta is defined' do
      resource = TestResource.new(TestModel.new, {})
      expected = {
        href: '/application-resource-test/tests/xyzzy/frobs',
        meta: { count: 3 }
      }
      assert_equal expected, subject.object_hash(resource)['relationships']['frobs']['links']['related']
      assert_equal({ serializer: subject, serialization_options: { foo: 42 } }, resource.frobs_meta_options)
    end

    test 'foo related link is string if foo_meta is not defined' do
      resource = TestResource.new(TestModel.new, {})
      expected = '/application-resource-test/tests/xyzzy/quux'
      assert_equal expected, subject.object_hash(resource)['relationships']['quux']['links']['related']
    end
  end
end
