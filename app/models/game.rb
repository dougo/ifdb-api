class Game < ApplicationRecord
  def author_id
    if authorExt
      ids = authorExt.scan(/{([^}]*)}/).flatten.map &:to_sym
      ids.size > 1 ? ids : ids.first
    end
  end
end
