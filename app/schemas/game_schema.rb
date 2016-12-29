class GameSchema < JSONSchema
  type :object
  string *%i(id title sort_title author sort_author), required: true
  string *%i(authorExt tags), required: true, null: true
  string :published, format: 'date-time', required: true, null: true
  string *%i(version license system language desc coverart seriesname seriesnumber genre forgiveness), {
    required: true, null: true
  }
  integer :bafsid, required: true, null: true
  string *%i(website downloadnotes), required: true, null: true
  string *%i(created moddate), format: 'date-time', required: true
  string :editedby, required: true
  integer :pagevsn, required: true
  property :_links, required: true, all_of: [
    # TODO: make a DSL for these
    { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
    { required: %i(self) }
  ]
end
