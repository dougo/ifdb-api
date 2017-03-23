class MemberSchema < ApplicationSchema
  property :attributes, required: true do
    string :name, required: true
    string :gender, max_length: 1
    string :publicemail, format: :email
    string :location
    string :profile
    string :since, format: 'date-time', required: true
  end
end
