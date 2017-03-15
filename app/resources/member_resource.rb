class MemberResource < ApplicationResource
  attributes *%i(name gender location publicemail profile picture created)

  has_many :games
end
