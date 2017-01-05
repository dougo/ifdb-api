class GameSchema < JSONSchema
  extend 'http://jsonapi.org/schema#/definitions/success'

  property :data do
    property :attributes, required: true do
      string *%i(title sort-title author sort-author), required: true
      string :'author-ext'
      string :tags
      string :published, format: 'date-time'
      string :version
      string :license
      string :system
      string :language
      string :desc
      string :coverart, format: :uri
      string :seriesname
      string :seriesnumber
      string :genre
      string :forgiveness
      integer :bafsid
      string :website, format: :uri
      string :downloadnotes
      string *%i(created moddate), format: 'date-time', required: true
      string :editedby, required: true
      integer :pagevsn, required: true
    end
    property :links, required: true do
      required :self
    end
  end
end
