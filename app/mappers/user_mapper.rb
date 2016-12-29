class UserMapper < Yaks::Mapper
  link :self, '/users/{id}'
  attributes *%i(id name gender publicemail location profile picture created)
end
