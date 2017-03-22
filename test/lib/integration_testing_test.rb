require 'test_helper'

class IntegrationTestingTest < ActiveSupport::TestCase
  test_extends ActiveSupport::Concern

  subject { Class.new(ActionDispatch::IntegrationTest) { include IntegrationTesting } }

  def test; @test ||= subject.new('') end

  test 'includes HyperResource::Adapter::JSON_API::Testing' do
    assert_includes subject, HyperResource::Adapter::JSON_API::Testing
  end

  test 'ifdb' do
    ifdb = test.ifdb
    assert_kind_of HyperResource, ifdb
    assert_equal HyperResource::Adapter::JSON_API, ifdb.adapter
    assert_same ifdb, test.ifdb
  end
end
