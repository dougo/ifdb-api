require 'test_helper'

class MemberResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  EXPECTED_ATTRS = %i(name gender location publicemail profile picture created)
end
