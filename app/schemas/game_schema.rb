class GameSchema < HALSchema
  type :object
  string *%i(id title sort_title author sort_author), required: true
  string *%i(authorExt tags), required: true, null: true
  string :published, format: 'date-time', required: true, null: true
  string *%i(version license system language desc), required: true, null: true
  string :coverart, format: :uri, required: true, null: true
  string *%i(seriesname seriesnumber genre forgiveness), required: true, null: true
  integer :bafsid, required: true, null: true
  string :website, format: :uri, required: true, null: true
  string :downloadnotes, required: true, null: true
  string *%i(created moddate), format: 'date-time', required: true
  string :editedby, required: true
  integer :pagevsn, required: true
end
