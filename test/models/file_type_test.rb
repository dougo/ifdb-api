require 'test_helper'

class FileTypeTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_many(:download_help).with_foreign_key(:fmtid)
end
