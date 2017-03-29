require 'test_helper'

class FetchGamesTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  test 'fetch all data needed by the games index page' do
    games = ifdb.games.get
    vals = {
      games: games.first(2).map do |game|
        {
          thumbnail: game.links[:thumbnail]&.url,
          url: game.url,
          title: game.title,
          author: game.author,
          published: game.attributes[:published], # TODO: should be game[:published]?
        }
      end,
      pages: {
        first: games.links[:first].url,
        prev: games.links[:prev]&.url,
        next: games.links[:next]&.url,
        last: games.links[:last].url
      }
    }
    expected = {
      games: [
        {
          thumbnail: 'http://ifdb.tads.org/viewgame?coverart&id=fft6pu91j85y4acv&thumbnail=80x80',
          url: 'http://www.example.com/games/xyzzy',
          title: 'Adventure',
          author: 'Will Crowther',
          published: nil
        },
        {
          thumbnail: nil,
          url: "http://www.example.com/games/#{games(:zork).id}",
          title: 'Zork',
          author: 'Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling',
          published: '1979-01-01T00:00:00.000Z'
        }
      ],
      pages: {
        first: 'http://www.example.com/games?page%5Bnumber%5D=1&page%5Bsize%5D=20',
        prev: nil,
        next: 'http://www.example.com/games?page%5Bnumber%5D=2&page%5Bsize%5D=20',
        last: 'http://www.example.com/games?page%5Bnumber%5D=6&page%5Bsize%5D=20'
      }
    }
    assert_equal expected, vals
  end

  test 'fetch all data needed by the game details page' do
    game = ifdb.games.links[:last].where(include: 'author-profiles').data.last
    vals = {
      coverart: game.coverart.url,
      large_thumbnail: game.large_thumbnail.url,
      title: game.title,
      author_profiles: game.objects.author_profiles.map(&:url),
      author: game.author,
      genre: game.genre,
      published_year: game.published.to_date.year,
      website: game.website.url,
      # TODO: ratings & reviews
      desc: game.desc,
      series: game.seriesname,
      episode: game.seriesnumber,
      language: game.language,
      language_names: game.language_names,
      published: game.published,
      version: game.version,
      license: game.license,
      system: game.system,
      bafsid: game.bafsid,
      forgiveness: game.forgiveness,
      ifids: game.ifids,
      tuid: game.id,
      # TODO: cross references
      # TODO: tags
      # TODO: awards
      # TODO: external reviews
      # TODO: member reviews
      # TODO: links
      # TODO: editor url/name
      # TODO: version/history links
      download_notes: game.downloadnotes,
      # TODO: download links
      players: game.players.url,
      players_count: game.players_count,
      wishlists: game.wishlists.url,
      wishlists_count: game.wishlists_count
    }
    expected = {
      coverart: 'http://ifdb.tads.org/viewgame?coverart&id=38iqpon2ekeryjcs&ldesc',
      large_thumbnail: 'http://ifdb.tads.org/viewgame?coverart&id=38iqpon2ekeryjcs&thumbnail=175x175',
      title: 'Max Blaster and Doris de Lightning Against the Parrot Creatures of Venus',
      author_profiles: ["http://www.example.com/members/#{members(:arthur).id}",
                        "http://www.example.com/members/#{members(:trillian).id}"],
      author: 'Dan Shiovitz and Emily Short',
      genre: 'Superhero/Espionage/Humor/Science Fiction',
      published_year: 2003,
      website: 'http://example.com/max',
      desc: 'Someplace on Venus a secret weapon is being built that threatens Earth with total destruction. ' \
            "You and your comrade must penetrate the Xavian base and save the world -- before it's too late!",
      series: 'Max Blaster',
      episode: '1',
      language: 'en-US, de, pt-BR',
      language_names: { 'en-US': 'English', 'de': 'German', 'pt-BR': 'Portuguese' },
      published: '2003-01-01T00:00:00.000Z',
      version: '1.0',
      license: 'Freeware',
      system: 'TADS 3',
      bafsid: 2096,
      forgiveness: 'Polite',
      ifids: [ifids(:max1).to_s, ifids(:max2).to_s],
      tuid: games(:maximal).id,
      download_notes: "To play, you'll need a TADS 3 Interpreter - visit tads.org for interpreter downloads.",
      players: "http://www.example.com/games/#{games(:maximal).id}/players",
      players_count: 2,
      wishlists: "http://www.example.com/games/#{games(:maximal).id}/wishlists",
      wishlists_count: 1
    }
    assert_equal expected, vals
  end

  # TODO: 'whoselist' page
end
