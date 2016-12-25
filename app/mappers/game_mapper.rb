class GameMapper < Yaks::Mapper
  link :self, '/games/{id}.json'
  attributes *%i(id title sort_title author sort_author)
end
