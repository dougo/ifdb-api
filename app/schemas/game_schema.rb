class GameSchema < ApplicationSchema
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
    string :seriesname
    string :seriesnumber
    string :genre
    string :forgiveness
    integer :bafsid
    string :downloadnotes
    string *%i(created moddate), format: 'date-time', required: true
    integer :pagevsn, required: true
  end
  property :relationships do
    property :editor do
      property :links, required: true do required *%i(self related) end
      property :data do
        property :type, value: :members
      end
    end
  end
end
