class Comment < ApplicationRecord
  self.table_name = 'ucomments'

  belongs_to :parent_comment, class_name: 'Comment', foreign_key: :parent
  belongs_to :commentable, polymorphic: true, foreign_key: :sourceid, foreign_type: :source
  belongs_to :author, class_name: 'Member', foreign_key: :userid
  has_many :replies, class_name: 'Comment', foreign_key: :parent

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
end
