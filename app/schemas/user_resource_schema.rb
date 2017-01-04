class UserResourceSchema < JSONSchema
  extend "http://jsonapi.org/schema#/definitions/success"

  property :data do
    property :attributes, required: true do
      string :name, required: true
      string :gender, max_length: 1
      string :publicemail, format: :email
      string :location, required: true
      string :profile
      string :picture, format: :uri
      string :created, format: 'date-time', required: true
    end
    property :links, required: true do
      required :self
    end
  end
end
