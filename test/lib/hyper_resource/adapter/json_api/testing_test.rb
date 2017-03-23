require 'test_helper'

class HyperResource::Adapter::JSON_API::TestingTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  subject { Class.new(ActionDispatch::IntegrationTest) { include HyperResource::Adapter::JSON_API::Testing } }

  def test; @test ||= subject.new('') end

  test 'includes HyperResource::Testing' do
    assert_includes subject, HyperResource::Testing
  end

  test 'new_jsonapi_hyper_resource' do
    resource = nil
    subject.instance_exec do
      define_method(:test_foo) do
        self.host = 'xyzzy.example.com'
        resource = new_jsonapi_hyper_resource
      end
    end
    test.test_foo
    assert_kind_of HyperResource, resource
    assert_equal 'http://xyzzy.example.com', resource.root
    assert_equal HyperResource::Adapter::JSON_API, resource.adapter
    assert_equal 'application/vnd.api+json', resource.headers['Accept']
  end

  test 'server exceptions set the backtrace' do
    subject.test 'foo' do
      body = { errors: [ meta: { exception: 'oops from server', backtrace: ['line 1', 'line 2'] } ] }
      raise HyperResource::ServerError.new('oops from client', body: body)
    end
    e = assert_raises(HyperResource::ServerError) { test.test_foo }
    assert_equal 'oops from server', e.message
    assert_equal ['line 1', 'line 2'], e.backtrace
  end
end
