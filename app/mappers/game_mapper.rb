class GameMapper < Yaks::Mapper
  link :self, '/games/{id}'
  attributes *%i(id title sort_title author sort_author authorExt tags published version license system language desc
                 coverart seriesname seriesnumber genre forgiveness)
end
