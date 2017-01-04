class UserResource < ApplicationResource
  immutable

  attributes *%i(name gender location publicemail profile picture created)
end
