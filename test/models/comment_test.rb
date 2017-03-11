require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:parent_comment).class_name('Comment').with_foreign_key(:parent)
  should belong_to(:commentable).with_foreign_key(:sourceid) # .with_foreign_type(:source)
  should belong_to(:author).class_name('Member').with_foreign_key(:userid)

  # TODO: add this to shoulda-matchers?
  test 'with_foreign_type(:source)' do
    assert_equal :source, self.class.described_type.reflect_on_association(:commentable).foreign_type
  end

  # TODO: add this to shoulda-matchers?
  test 'have_attribute(:source, Comment::SourceTypeName)' do
    assert_instance_of Comment::SourceTypeName, self.class.described_type.attribute_types['source']
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

class Comment::SourceTypeNameTest < ActiveSupport::TestCase
  test 'is a String' do
    assert_operator self.class.described_type, :<, ActiveRecord::Type::String
  end

  { 'L' => 'RecommendedList', 'P' => 'Poll', 'R' => 'Review', 'U' => 'Member' }.each do |abbr, name|
    test "serialize #{name}" do
      assert_equal abbr, subject.serialize(name)
    end

    test "deserialize #{name}" do
      assert_equal name, subject.deserialize(abbr)
    end
  end

  test 'serialize unknown type' do
    assert_nil subject.serialize('Xebec')
  end

  test 'deserialize unknown type' do
    assert_nil subject.deserialize('X')
  end
end
