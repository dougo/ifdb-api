require 'test_helper'

class SpecialReviewerTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_db_column(:displayrank).of_type(:integer).with_options(null: false)
  should have_db_column(:code).of_type(:string).with_options(null: false)
  should have_db_column(:name).of_type(:string).with_options(null: false)
end
