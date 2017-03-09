class MemberMapper < ApplicationMapper
  link :self, '/members/{id}'
  attributes *%i(id name gender publicemail location profile picture created)
end
