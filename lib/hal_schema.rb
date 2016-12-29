class HALSchema < JSONSchema
  property :_links, all_of: [
    # TODO: make a DSL for these
    { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
    { required: %i(self) }
  ]
end
