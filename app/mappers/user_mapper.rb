class UserMapper < ApplicationMapper
  link :self, '/users/{id}'
  attributes *%i(id name gender publicemail location profile picture created)
end
