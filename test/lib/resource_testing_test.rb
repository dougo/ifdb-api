require 'test_helper'

class ResourceTestingTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  class TestModel; end
  class TestResource < JSONAPI::Resource
    model_name TestModel.name
    attributes *%i(foo bar)
  end

  subject { Class.new(Minitest::Test) { include ResourceTesting; @described_type = TestResource } }

  def test; @test ||= subject.new('') end

  should 'add a test for extending ApplicationResource' do
    assert subject.method_defined?(:test_extends_ApplicationResource)
  end

  test 'test_attributes should define a test method' do
    subject.test_attributes %i(foo bar)
    assert subject.method_defined?(:test_attributes_foo_bar)
  end

  test 'test_attributes test should pass if the resource class defines the given attributes' do
    subject.test_attributes %i(foo bar)
    assert test.test_attributes_foo_bar
  end

  test 'test_attributes test should fail if the resource class does not define the given attributes' do
    subject.test_attributes %i(baz quux)
    assert_raises(Minitest::Assertion) { test.test_attributes_baz_quux }
  end

  test 'subject sould be an instance of the resource' do
    assert_kind_of TestResource, test.subject
  end

  test 'subject model should be an instance of the model' do
    assert_kind_of TestModel, test.subject._model
  end
end
