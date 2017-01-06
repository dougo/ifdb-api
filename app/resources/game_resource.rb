class GameResource < ApplicationResource
  immutable

  attributes *%i(title sort_title author sort_author authorExt tags published version license system language desc
                 coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created moddate
                 pagevsn)

  has_one :editor, class_name: 'User', foreign_key: :editedby
end
