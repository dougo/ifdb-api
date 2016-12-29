class GameSchema < HALSchema
  type :object
  string *%i(id title sort_title author sort_author), null: false
  string *%i(authorExt tags)
  string :published, format: 'date-time'
  string *%i(version license system language desc)
  string :coverart, format: :uri
  string *%i(seriesname seriesnumber genre forgiveness)
  integer :bafsid
  string :website, format: :uri
  string :downloadnotes
  string *%i(created moddate), format: 'date-time', null: false
  string :editedby, null: false
  integer :pagevsn, null: false
end
