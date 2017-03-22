require 'test_helper'

class HyperResource::TestingTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  subject { Class.new(ActionDispatch::IntegrationTest) { include HyperResource::Testing } }

  def test; @test ||= subject.new('') end

  class HyperResource::Testing::FaradayAdapterTest < ActiveSupport::TestCase
    test_extends Faraday::Adapter::Rack

    subject { self.class.described_type.new(-> env { env.body }) }

    test 'registered' do
      assert_equal self.class.described_type, Faraday::Adapter.lookup_middleware(:integration_test)
    end

    test 'app is the test app' do
      ActionDispatch::IntegrationTest.app = -> env { [nil, {}, 'xyzzy'] }
      env = Faraday::Env.from(url: URI('http://www.example.com'), request: {})
      begin
        assert_equal 'xyzzy', subject.call(env)
      ensure
        ActionDispatch::IntegrationTest.app = nil
      end
    end
  end

  test 'default_adapter is integration_test during tests' do
    before_adapter = Faraday.default_adapter
    refute_equal :integration_test, before_adapter

    test.name = :test_foo
    during_adapter = nil
    subject.instance_exec { define_method(:test_foo) { during_adapter = Faraday.default_adapter } }
    test.run
    assert_equal :integration_test, during_adapter

    assert_equal before_adapter, Faraday.default_adapter
  end
end
