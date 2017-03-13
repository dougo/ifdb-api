require 'test_helper'

class ApplicationMapperTest < ActiveSupport::TestCase
  test_extends Yaks::Mapper

  class TestModel
    def foo; nil end
    def bar; 42 end
  end

  class TestModelMapper < ApplicationMapper
    attributes :foo, :bar
  end

  test 'omits nil attributes' do
    model = TestModel.new
    mapper = TestModelMapper.new(policy: Yaks.new.policy)
    mapper.call(model)
    assert_equal [:bar], mapper.attributes.map(&:name)
  end
end
