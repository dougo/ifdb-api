class UserSchema < HALSchema
  type :object
  string :id, required: true
  string :name, required: true
  string :gender, max_length: 1, required: true, null: true
  string :publicemail, format: :email, required: true, null: true
  string :location, required: true
  string :profile, required: true, null: true
  string :picture, format: :uri, required: true, null: true
  string :created, format: 'date-time', required: true, null: true
end
