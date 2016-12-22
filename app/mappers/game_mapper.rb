class GameMapper < Yaks::Mapper
  attributes *%i(id title sort_title author sort_author)
end
