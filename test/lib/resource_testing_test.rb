require 'test_helper'

class ResourceTestingTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  class TestModel < OpenStruct; end
  class TestResource < JSONAPI::Resource
    model_name TestModel.name
    attributes *%i(foo bar)
    has_one *%i(baz quux)
    has_many *%i(widgets sprockets)
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

  test 'test_has_many should define test methods' do
    subject.test_has_many *%i(widgets sprockets)
    assert subject.method_defined?(:test_has_many_widgets)
    assert subject.method_defined?(:test_has_many_sprockets)
  end

  test 'test_has_many test should pass if the resource class defines the given has_many relationships' do
    subject.test_has_many *%i(widgets sprockets)
    assert test.test_has_many_widgets
    assert test.test_has_many_sprockets
  end

  test 'test_has_many test should fail if the resource class does not define the given has_many relationships' do
    subject.test_has_many *%i(baz quux)
    assert_raises(Minitest::Assertion) { test.test_has_many_baz }
    assert_raises(Minitest::Assertion) { test.test_has_many_quux }
  end

  test 'subject sould be an instance of the resource' do
    assert_kind_of TestResource, test.subject
  end

  test 'subject model should be an instance of the model' do
    assert_kind_of TestModel, test.subject._model
  end

  test 'serialize' do
    model = TestModel.new(id: 'xyzzy', foo: 42, bar: 23)
    expected = { id: 'xyzzy', type: 'tests', links: { self: '/resource-testing-test/tests/xyzzy' },
                 attributes: { foo: 42, bar: 23 } }
    assert_equal expected.with_indifferent_access, test.serialize(model).slice(*%i(id type links attributes))
  end
end
