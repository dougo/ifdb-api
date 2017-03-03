class MemberSchema < ApplicationSchema
  property :attributes, required: true do
    string :name, required: true
    string :gender, max_length: 1
    string :publicemail, format: :email
    string :location, required: true
    string :profile
    string :picture, format: :uri
    string :created, format: 'date-time', required: true
  end
end
