class Game < ApplicationRecord
  def author_id
    if authorExt =~ /{([^}]*)}/
      $1.to_sym
    end
  end
end
