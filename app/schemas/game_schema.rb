class GameSchema < JSONSchema
  type :object
  string *%i(id title sort_title author sort_author), required: true
  string :authorExt, required: true, null: true
  property :_links, required: true, all_of: [
    # TODO: make a DSL for these
    { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
    { required: %i(self) }
  ]
end
