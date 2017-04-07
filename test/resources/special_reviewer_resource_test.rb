require 'test_helper'

class SpecialReviewerResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(displayrank code name)
end
