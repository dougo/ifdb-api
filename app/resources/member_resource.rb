class MemberResource < ApplicationResource
  attributes *%i(name gender location publicemail profile picture created)
end
