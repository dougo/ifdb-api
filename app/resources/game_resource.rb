class GameResource < ApplicationResource
  attributes *%i(title sort_title author sort_author authorExt tags published version license system language desc
                 coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created moddate
                 pagevsn)

  has_many :author_profiles

  has_one :editor, class_name: 'Member', foreign_key: :editedby
end
