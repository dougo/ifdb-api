require 'test_helper'

class CompoundIDTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  class TestModel
    def self.primary_key; end
    def fooid; 'foo' end
    def barid; 'bar' end
  end

  class TestResource < JSONAPI::Resource
    include CompoundID

    model_name TestModel.name

    compound_id %i(fooid barid)
  end

  subject { TestResource.new(TestModel.new, {}) }

  test '_compound_id' do
    assert_equal %i(fooid barid), TestResource._compound_id
  end

  test 'primary_key' do
    assert_equal :id, TestResource._primary_key
  end

  test 'id' do
    assert_equal 'foo-bar', subject.id
  end

  test 'id filter' do
    filter = TestResource._allowed_filters[:id][:apply]
    mock_relation = Class.new { def where(condition); condition end }.new
    assert_equal({ fooid: 'foo', barid: 'bar' }, filter.call(mock_relation, 'foo-bar', {}))
  end
end
