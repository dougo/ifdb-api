require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_and_belong_to_many(:author_members).class_name('Member').join_table('gameprofilelinks')
  should have_many(:reviews).with_foreign_key(:gameid)
  should have_many(:awards).class_name('CompetitionGame').with_foreign_key(:gameid)
  should have_many(:competitions).through(:awards)
  # TODO: tags
  should have_many(:list_items).class_name('RecommendedListItem').with_foreign_key(:gameid)
  should have_many(:lists).through(:list_items)
  should have_many(:poll_votes).with_foreign_key(:gameid)
  should have_many(:polls).through(:poll_votes)

  test 'polls relation is distinct' do
    # TODO: add this to shoulda-matchers?
    reflector = Shoulda::Matchers::ActiveRecord::AssociationMatchers::ModelReflector.new(subject, :polls)
    rel = reflector.association_relation
    assert_kind_of Arel::Nodes::Distinct, rel.ast.cores.last.set_quantifier
  end

  should belong_to(:editor).class_name('Member').with_foreign_key(:editedby)
  should have_many(:links).class_name('GameLink').with_foreign_key(:gameid)
  should have_and_belong_to_many(:players).class_name('Member').join_table('playedgames')
  should have_and_belong_to_many(:wishlists).class_name('Member').join_table('wishlists')
end
