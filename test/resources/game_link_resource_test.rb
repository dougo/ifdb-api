require 'test_helper'

class GameLinkResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test 'compound_id' do
    assert_equal %i(gameid displayorder), GameLinkResource._compound_id
  end

  test_attributes %i(displayorder title desc)

  test 'custom_links' do
    subject._model.url = 'http://www.example.com'
    assert_equal({ file: 'http://www.example.com' }, subject.custom_links({}))
  end

  test 'default_sort' do
    assert_nil GameLinkResource.default_sort
  end
end
