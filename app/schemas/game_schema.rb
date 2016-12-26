class GameSchema
  def schema
    {
      :$schema => JSON::Validator.validator_for_name(:draft4).uri.to_s,
      type: :object,
      properties: {
        _links: {
          allOf: [
            { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
            { required: %i(self) }
          ]
        },
        id:          { type: :string },
        title:       { type: :string },
        sort_title:  { type: :string },
        author:      { type: :string },
        sort_author: { type: :string },
        authorExt:   { type: %i(string null) }
      },
      required: %i(_links id title sort_title author sort_author authorExt)
    }
  end
end
