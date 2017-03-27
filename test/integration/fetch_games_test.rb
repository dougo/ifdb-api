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
    game = ifdb.games.links[:last].data.last
    vals = {
      coverart: game.coverart.url,
      large_thumbnail: game.large_thumbnail.url,
      title: game.title,
      author_profiles: game.author_profiles.to_a.map(&:url), # TODO: include author-profiles
      author: game.author,
      genre: game.genre,
      published_year: game.published.to_date.year,
      website: game.website.url,
      # TODO: ratings & reviews
      desc: game.desc,
      # TODO: language
      published: game.published,
      version: game.version,
      license: game.license,
      system: game.system,
      forgiveness: game.forgiveness,
      # TODO: ifids
      tuid: game.id
      # TODO: tags
      # TODO: awards
      # TODO: external reviews
      # TODO: member reviews
      # TODO: links
      # TODO: editor url/name
      # TODO: version/history links
      # TODO: download links
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
      published: '2003-01-01T00:00:00.000Z',
      version: '1.0',
      license: 'Freeware',
      system: 'TADS 3',
      forgiveness: 'Polite',
      tuid: games(:maximal).id
    }
    assert_equal expected, vals
  end
end
