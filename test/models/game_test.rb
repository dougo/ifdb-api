require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_and_belong_to_many(:author_profiles).class_name('Member').join_table('gameprofilelinks')
  should have_many(:ratings).class_name('Review').with_foreign_key(:gameid)
  should have_many(:reviews_and_ratings).class_name('Review').with_foreign_key(:gameid)
  should have_many(:ifids).class_name('IFID').with_foreign_key(:gameid)
  should have_many(:cross_references).with_foreign_key(:fromid)
  should have_many(:awards).class_name('CompetitionGame').with_foreign_key(:gameid)
  should have_many(:competitions).through(:awards)
  should have_many(:news).class_name('NewsItem').with_foreign_key(:sourceid)
    # .as(:newsworthy).with_foreign_type(:source)
  should have_many(:editorial_reviews).with_foreign_key(:gameid)
  should have_many(:game_tags).with_foreign_key(:gameid)
  should have_many(:tag_stats).through(:game_tags).source(:stats)
  should have_many(:member_reviews).class_name('Review').with_foreign_key(:gameid)
  should have_many(:cross_recommendations).with_foreign_key(:fromgame)
  should have_many(:related).through(:cross_recommendations).source(:to)
  should have_many(:list_items).class_name('RecommendedListItem').with_foreign_key(:gameid)
  should have_many(:lists).through(:list_items)
  should have_many(:poll_votes).with_foreign_key(:gameid)
  should have_many(:polls).through(:poll_votes)
  should belong_to(:editor).class_name('Member').with_foreign_key(:editedby)
  should have_many(:history).class_name('GameVersion').with_foreign_key(:id)
  should have_many(:download_links).class_name('GameLink').with_foreign_key(:gameid)
  should have_and_belong_to_many(:players).class_name('Member').join_table('playedgames')
  should have_and_belong_to_many(:wishlists).class_name('Member').join_table('wishlists')

  # TODO: use mock, expect call to :ratings scope?
  test 'ratings collection omits review-only' do
    assert_same_elements reviews(:of_zork, :rating_only, :external), games(:zork).ratings
  end

  # TODO: is this actually used anywhere?
  test 'reviews_and_ratings collection includes all' do
    assert_same_elements reviews(:of_zork, :rating_only, :review_only, :external, :bafs_guide),
                         games(:zork).reviews_and_ratings
  end

  # TODO: use mock, expect call to :member_reviews scope?
  test 'member_reviews collection omits ratings-only and editorial' do
    assert_same_elements reviews(:of_zork, :review_only), games(:zork).member_reviews
  end

  test 'polls collection is distinct' do
    # TODO: add this to shoulda-matchers?
    reflector = Shoulda::Matchers::ActiveRecord::AssociationMatchers::ModelReflector.new(subject, :polls)
    rel = reflector.association_relation
    assert_kind_of Arel::Nodes::Distinct, rel.ast.cores.last.set_quantifier
  end

  test 'download_links are sorted by displayorder' do
    reflector = Shoulda::Matchers::ActiveRecord::AssociationMatchers::ModelReflector.new(subject, :download_links)
    rel = reflector.association_relation
    assert_equal 1, rel.order_values.length
    order = rel.order_values.first
    assert_kind_of Arel::Nodes::Ascending, order
    assert_equal :displayorder, order.expr.name
  end

  test 'language_names' do
    subject.language = 'eng-US, de'
    assert_equal({ 'eng-US': 'English', de: 'German' }, subject.language_names)
  end

  test 'language_names when blank' do
    subject.language = ''
    assert_nil subject.language_names
  end

  test 'language_names when not found' do
    subject.language = 'english'
    assert_equal({ 'english': nil }, subject.language_names)
  end
end
