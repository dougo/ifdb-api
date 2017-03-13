require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_many(:news).class_name('NewsItem').with_foreign_key(:sourceid)
    # .as(:newsworthy).with_foreign_type(:source)
  should have_many(:club_memberships).with_foreign_key(:clubid)
  should have_many(:members).through(:club_memberships)
  # TODO: wishlist and playlist
end
