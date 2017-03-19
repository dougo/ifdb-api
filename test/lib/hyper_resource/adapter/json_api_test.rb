require 'test_helper'

class HyperResource::Adapter::JSON_APITest < ActiveSupport::TestCase
  test_extends HyperResource::Adapter

  subject { self.class.described_type }

  test 'serialize' do
    assert_equal '{"data":{"id":23}}', subject.serialize(data: { id: 23 })
  end

  test 'deserialize' do
    assert_equal({ data: { id: 23 } }, subject.deserialize('{"data":{"id":23}}'))
  end

  test 'apply' do
    response = {
      data: {
        id: 23,
        type: 'widgets',
        attributes: { name: 'Encabulator' },
        links: { self: 'http://www.example.com/widgets/23' }
      },
      links: {
        docs: 'http://www.flobee.net/re_transcript.html'
      }
    }
    resource = HyperResource.new
    assert_same resource, subject.apply(response, resource)
    assert_predicate resource, :loaded
    assert_equal 'http://www.example.com/widgets/23', resource.href
    assert_equal({ 'id' => 23, 'type' => 'widgets', 'name' => 'Encabulator' }, resource.attributes)
    assert_same resource, resource.links[:self].resource
    assert_equal 'http://www.example.com/widgets/23', resource.links[:self].href
    assert_equal 'http://www.flobee.net/re_transcript.html', resource.links[:docs].href
  end

  test 'apply when primary data is an array' do
    response = { data: [{ id: 23, type: 'widgets', attributes: { name: 'Encabulator' } }] }
    resources = HyperResource.new
    subject.apply(response, resources)
    resource = resources.objects[:data].first
    assert_equal({ 'id' => 23, 'type' => 'widgets', 'name' => 'Encabulator' }, resource.attributes)
    assert_predicate resource, :loaded
  end
end
