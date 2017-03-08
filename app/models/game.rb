class Game < ApplicationRecord
  belongs_to :editor, class_name: 'User', foreign_key: :editedby
  has_many :links, class_name: 'GameLink', foreign_key: :gameid
  has_many :list_items, class_name: 'RecommendedListItem', foreign_key: :gameid
  has_many :lists, through: :list_items

  def author_id
    if authorExt
      ids = authorExt.scan(/{([^}]*)}/).flatten.map &:to_sym
      ids.size > 1 ? ids : ids.first
    end
  end
end
