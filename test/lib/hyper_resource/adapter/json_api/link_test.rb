require 'test_helper'

class HyperResource::Adapter::JSON_API::LinkTest < ActiveSupport::TestCase
  test_extends HyperResource::Link

  test 'meta' do
    hr = HyperResource.new
    subject = self.class.described_type.new(hr, meta: { foo: 23 })
    meta = subject.meta
    assert_kind_of HyperResource::Attributes, meta
    assert_same hr, meta._resource
    assert_equal({ 'foo' => 23 }, meta)
  end

  test 'meta is nil' do
    subject = self.class.described_type.new(HyperResource.new)
    assert_nil subject.meta
  end
end
