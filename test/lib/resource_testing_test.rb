require 'test_helper'

class ResourceTestingTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  class TestResource < JSONAPI::Resource
    attributes *%i(foo bar)
  end

  subject { Class.new(Minitest::Test) { include ResourceTesting; @described_type = TestResource } }

  should 'add a test for extending ApplicationResource' do
    assert subject.method_defined?(:test_extends_ApplicationResource)
  end

  context 'test_attributes' do
    should 'define a test method' do
      subject.test_attributes %i(foo bar)
      assert subject.method_defined?(:test_attributes_foo_bar)
    end

    context 'defines a test method that' do
      setup { @test = subject.new('') }

      should 'pass if the resource class defines the given attributes' do
        subject.test_attributes %i(foo bar)
        assert @test.test_attributes_foo_bar
      end

      should 'fail if the resource class does not define the given attributes' do
        subject.test_attributes %i(baz quux)
        assert_raises(Minitest::Assertion) { @test.test_attributes_baz_quux }
      end
    end
  end
end
