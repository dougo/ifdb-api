require 'test_helper'

class CrossRecommendationTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:from).class_name('Game').with_foreign_key(:fromgame)
  should belong_to(:to).class_name('Game').with_foreign_key(:togame)
  should belong_to(:recommender).class_name('Member').with_foreign_key(:userid)
end
