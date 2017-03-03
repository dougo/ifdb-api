class MemberResource < ApplicationResource
  model_name 'User'
  immutable

  attributes *%i(name gender location publicemail profile picture created)
end
