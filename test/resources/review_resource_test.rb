require 'test_helper'

class ReviewResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(summary review rating createdate moddate embargodate)
end
