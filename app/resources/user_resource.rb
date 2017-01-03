class UserResource < JSONAPI::Resource
  immutable

  attributes *%i(name gender location publicemail profile picture created)
end
