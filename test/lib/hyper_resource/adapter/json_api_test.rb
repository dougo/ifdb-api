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
        attributes: { 'full-name': 'Encabulator' },
        relationships: {
          'hydrocoptic-marzelvanes': {
            links: {
              related: {
                href: 'http://www.example.com/widgets/23/hydrocoptic-marzelvanes',
                meta: { count: 23 }
              }
            },
            data: [ { id: 42, type: 'parts' } ]
          },
          'spiral-decommutator': {
            links: { related: 'http://www.example.com/widgets/23/spiral-decommutator' },
            data: nil
          }
        },
        links: { self: 'http://www.example.com/widgets/23' }
      },
      included: [
        { id: 42, type: 'parts', attributes: { name: 'ambifacient lunar waneshaft' } }
      ],
      links: {
        docs: 'http://www.flobee.net/re_transcript.html?foo=bar'
      }
    }
    resource = HyperResource.new(root: 'http://www.example.com', adapter: subject)
    assert_same resource, subject.apply(response, resource)
    assert_equal 'http://www.example.com/widgets/23', resource.href
    assert_equal({ 'id' => 23, 'type' => 'widgets', 'full_name' => 'Encabulator' }, resource.attributes)

    self_link = resource.links.self
    assert_same resource, self_link.resource
    assert_equal 'http://www.example.com/widgets/23', self_link.base_href

    hcmv_link = resource.links.hydrocoptic_marzelvanes
    assert_equal 'http://www.example.com/widgets/23/hydrocoptic-marzelvanes', hcmv_link.base_href
    assert_equal(23, hcmv_link.meta[:count])
    assert_equal 'http://www.example.com/widgets/23/hydrocoptic-marzelvanes',
                 response[:data][:relationships][:'hydrocoptic-marzelvanes'][:links][:related][:href],
                 'response body href should not be modified'

    docs_link = resource.links.docs
    assert_equal 'http://www.flobee.net/re_transcript.html?foo=bar', docs_link.base_href

    hcmv_part = resource.objects.hydrocoptic_marzelvanes.first
    assert_equal({ 'id' => 42, 'type' => 'parts', 'name' => 'ambifacient lunar waneshaft' }, hcmv_part.attributes)

    refute resource.objects.respond_to?(:spiral_decommutator)
  end

  test 'apply when primary data is an array' do
    response = { data: [{ id: 23, type: 'widgets', attributes: { name: 'Encabulator' } }] }
    resources = HyperResource.new(root: 'http://www.example.com', adapter: subject)
    subject.apply(response, resources)
    resource = resources.objects.data.first
    assert_equal({ 'id' => 23, 'type' => 'widgets', 'name' => 'Encabulator' }, resource.attributes)
  end

  test 'apply when the response has no attributes' do
    response = { data: { id: '', type: '' } }
    resource = subject.apply(response, HyperResource.new)
    assert_equal({ 'id' => '', 'type' => '' }, resource.attributes)
  end
end
