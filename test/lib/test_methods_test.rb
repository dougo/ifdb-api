require 'test_helper'

class TestMethodsTest < ActiveSupport::TestCase
  test 'extends Concern' do
    assert_operator TestMethods.singleton_class, :<, ActiveSupport::Concern
  end

  context 'test_extends' do
    subject { Class.new(Minitest::Test) { include TestMethods } }

    should 'define a test method' do
      subject.test_extends Object
      assert subject.method_defined?(:test_extends_Object)
    end

    context 'defines a test method that, when the described type is' do
      setup do
        @test = subject.new('')
        class << subject; attr_writer :described_type end
      end

      context 'a class,' do
        setup { subject.described_type = String }

        should 'pass if the class extends the given module' do
          subject.test_extends Object
          assert @test.test_extends_Object
        end

        should 'fail if the class does not extend the given module' do
          subject.test_extends Numeric
          assert_raises(Minitest::Assertion) { @test.test_extends_Numeric }
        end
      end

      context 'a module,' do
        setup { subject.described_type = Module.new { extend Enumerable } }

        should 'pass if the module extends the given module' do
          subject.test_extends Enumerable
          assert @test.test_extends_Enumerable
        end

        should 'fail if the module does not extend the given module' do
          subject.test_extends Comparable
          assert_raises(Minitest::Assertion) { @test.test_extends_Comparable }
        end
      end
    end
  end
end
