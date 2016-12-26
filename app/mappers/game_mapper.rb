class GameMapper < Yaks::Mapper
  link :self, '/games/{id}'
  attributes *%i(id title sort_title author sort_author authorExt)
end
