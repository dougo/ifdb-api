require 'test_helper'

class FileTypeTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:download_help).with_foreign_key(:fmtid)
end
