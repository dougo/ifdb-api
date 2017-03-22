require 'test_helper'

class FetchGamesTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  test 'fetch all data needed by the games index page' do
    games = ifdb.games
    vals = games.first(2).map do |game|
      {
        thumbnail: game.links[:thumbnail]&.url,
        url: game.url,
        title: game.title,
        author: game.author,
        published: game.attributes[:published] # TODO: should be game[:published]?
      }
    end
    expected = [
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
    ]
    assert_equal expected, vals
    # TODO: pagination
  end
end
