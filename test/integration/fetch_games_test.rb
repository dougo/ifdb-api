require 'test_helper'

class FetchGamesTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  test 'fetch all data needed by the games index page' do
    games = ifdb.games
    vals = games.first(2).map do |game|
      {
        # TODO: thumbnail, url, published
        url: game.url,
        title: game.title,
        author: game.author,
        published: game.attributes[:published] # TODO: should be game[:published]
      }
    end
    expected = [
      {
        url: 'http://www.example.com/games/xyzzy',
        title: 'Adventure',
        author: 'Will Crowther',
        published: nil
      },
      {
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
