class Comment < ApplicationRecord
  self.table_name = 'ucomments'

  belongs_to :parent_comment, class_name: 'Comment', foreign_key: :parent
  belongs_to :commentable, polymorphic: true, foreign_key: :sourceid, foreign_type: :source
  belongs_to :author, class_name: 'Member', foreign_key: :userid
  has_many :replies, class_name: 'Comment', foreign_key: :parent

  scope :inbox_for, -> (member) do
    includes_commentable.includes_parent.relevant_to(member)
  end

  class SourceTypeName < ActiveRecord::Type::String
    TYPE_NAMES = { 'L' => 'RecommendedList', 'P' => 'Poll', 'R' => 'Review', 'U' => 'Member' }.freeze

    def serialize(value)
      TYPE_NAMES.invert[value]
    end

    def deserialize(value)
      TYPE_NAMES[value]
    end
  end

  attribute :source, SourceTypeName.new

  private

  scope :includes_parent, -> do
    left_outer_joins(:parent_comment).references(:parent_comments_ucomments)
  end
  scope :includes_commentable, -> do
    includes_profile.includes_review.includes_list.includes_poll
  end
  scope :includes_profile, -> do
    joins('left join users profiles on profiles.id = ucomments.sourceid and ucomments.source = "U"')
      .references(:profiles)
  end
  scope :includes_review, -> do
    joins('left join reviews on reviews.id = ucomments.sourceid and ucomments.source = "R"')
      .references(:reviews)
  end
  scope :includes_list, -> do
    joins('left join reclists on reclists.id = ucomments.sourceid and ucomments.source = "L"')
      .references(:reclists)
  end
  scope :includes_poll, -> do
    joins('left join polls on polls.pollid = ucomments.sourceid and ucomments.source = "P"')
      .references(:polls)
  end
  scope :relevant_to, -> (member) do
    where(profiles: { id: member })
      .or(where(reviews: { userid: member }))
      .or(where(reclists: { userid: member }))
      .or(where(polls: { userid: member }))
      .or(where(parent_comments_ucomments: { userid: member }))
  end
end
