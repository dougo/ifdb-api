require 'test_helper'

class OffsiteReviewTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_db_column(:reviewid).of_type(:integer).with_options(unsigned: true)
  should have_db_column(:url).of_type(:text).with_options(null: false)
  should have_db_column(:sourcename).of_type(:string).with_options(null: false)
  should have_db_column(:sourceurl).of_type(:text)
  should have_db_column(:displayorder).of_type(:integer)

  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:review).with_foreign_key(:reviewid)
end
