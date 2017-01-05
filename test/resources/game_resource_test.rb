require 'test_helper'

class GameResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  EXPECTED_ATTRS = %i(title sort_title author sort_author authorExt tags published version license system language
                      desc coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created
                      moddate editedby pagevsn)
end
