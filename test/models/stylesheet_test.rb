require 'test_helper'

class StylesheetTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:author).class_name('Member').with_foreign_key(:userid)
end
