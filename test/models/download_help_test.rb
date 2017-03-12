require 'test_helper'

class DownloadHelpTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:file_type).with_foreign_key(:fmtid)
  should belong_to(:operating_system).with_foreign_key(:osid)
  should belong_to(:operating_system_version).with_foreign_key(:osvsnid)
end
