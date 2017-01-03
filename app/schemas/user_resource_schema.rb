class UserResourceSchema < JSONSchema
  extend "http://jsonapi.org/schema#/definitions/success"

  property :data, required: false do
    property :attributes do
      string :name, null: false
      string :gender, max_length: 1
      string :publicemail, format: :email
      string :location, null: false
      string :profile
      string :picture, format: :uri
      string :created, format: 'date-time', null: false
    end
    property :links do
      required :self
    end
  end
end
