require 'test_helper'

class OffsiteReviewResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test 'primary_key' do
    assert_equal :reviewid, OffsiteReviewResource._primary_key
  end

  test_attributes %i(displayorder sourcename)

  test 'custom_links' do
    subject._model.sourceurl = 'http://example.com'
    subject._model.url = 'http://example.com/areview'
    assert_equal 'http://example.com', subject.custom_links({})[:source]
    assert_equal 'http://example.com/areview', subject.custom_links({})[:full_review]
  end

  test 'no links if blank' do
    subject._model.url = ''
    refute_includes subject.custom_links({}), :source
    refute_includes subject.custom_links({}), :full_review
  end
end
