class GameMapper < ApplicationMapper
  link :self, '/games/{id}'
  attributes *%i(id title sort_title author sort_author authorExt tags published version license system language desc
                 coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created editedby
                 moddate pagevsn)
end
