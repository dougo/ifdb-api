require 'test_helper'

class StylesheetTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:author).class_name('Member').with_foreign_key(:userid)
end
