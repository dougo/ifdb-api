require 'test_helper'

class GameLinkTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:file_type).with_foreign_key(:fmtid)
  should belong_to(:operating_system).with_foreign_key(:osid)
  should belong_to(:operating_system_version).with_foreign_key(:osvsn)
end
