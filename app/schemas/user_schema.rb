class UserSchema < HALSchema
  type :object
  string *%i(id name), null: false
  string :gender, max_length: 1
  string :publicemail, format: :email
  string :location, null: false
  string :profile
  string :picture, format: :uri
  string :created, format: 'date-time'
end
