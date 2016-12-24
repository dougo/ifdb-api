class GameSchema
  def schema
    {
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
        sort_author: { type: :string }
      },
      required: %i(_links id title sort_title author sort_author)
    }
  end
end
