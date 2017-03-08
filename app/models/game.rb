class Game < ApplicationRecord
  belongs_to :editor, class_name: 'User', foreign_key: :editedby
  has_many :links, class_name: 'GameLink', foreign_key: :gameid

  def author_id
    if authorExt
      ids = authorExt.scan(/{([^}]*)}/).flatten.map &:to_sym
      ids.size > 1 ? ids : ids.first
    end
  end
end
