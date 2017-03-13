require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  test 'source attribute' do
    type = self.class.described_type.attribute_types['source']
    assert_instance_of SourceTypeName, type
    assert_equal({ 'L' => 'RecommendedList', 'P' => 'Poll', 'R' => 'Review', 'U' => 'Member' }, type.name_map)
  end

  should belong_to(:parent_comment).class_name('Comment').with_foreign_key(:parent)
  should belong_to(:commentable).with_foreign_key(:sourceid) # .with_foreign_type(:source)
  should belong_to(:author).class_name('Member').with_foreign_key(:userid)

  # TODO: add this to shoulda-matchers?
  test 'with_foreign_type(:source)' do
    assert_equal :source, self.class.described_type.reflect_on_association(:commentable).foreign_type
  end

  should have_many(:replies).class_name('Comment').with_foreign_key(:parent)

  context 'inbox_for' do
    subject { Comment.inbox_for(members(:arthur)) }

    should 'include comments on member profile' do
      assert_includes subject, comments(:on_arthur_profile)
    end
    should 'include comments on member reviews' do
      assert_includes subject, comments(:on_arthur_review)
    end
    should 'include comments on member lists' do
      assert_includes subject, comments(:on_arthur_list)
    end
    should 'include comments on member polls' do
      assert_includes subject, comments(:on_arthur_poll)
    end
    should 'include replies to member comments' do
      assert_includes subject, comments(:reply_to_arthur)
    end
  end
end
