require 'test_helper'

class FetchGamesTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  test 'fetch all data needed by the games index page' do
    games = ifdb.games.get
    vals = {
      games: games.first(2).map do |game|
        {
          thumbnail: game.try(:thumbnail)&.url,
          url: game.url,
          title: game.title,
          author: game.author,
          published_year: game.try(:published)&.to_date&.year,
          ratings_average: game.ratings.meta.average
        }
      end,
      pages: {
        first: games.links[:first].url,
        prev: games.try(:prev)&.url,
        next: games.try(:next)&.url,
        last: games.last.url
      }
    }
    expected = {
      games: [
        {
          thumbnail: 'http://ifdb.tads.org/viewgame?coverart&id=fft6pu91j85y4acv&thumbnail=80x80',
          url: 'http://www.example.com/games/xyzzy',
          title: 'Adventure',
          author: 'Will Crowther',
          published_year: nil,
          ratings_average: nil
        },
        {
          thumbnail: nil,
          url: "http://www.example.com/games/#{games(:zork).id}",
          title: 'Zork',
          author: 'Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling',
          published_year: 1979,
          ratings_average: 3.6666666666666665
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
    game = ifdb.games.last.data.last.self(include: %w(author-profiles member-reviews.reviewer download-links)).get
    vals = {
      coverart: game.coverart.url,
      large_thumbnail: game.large_thumbnail.url,
      title: game.title,
      author_profiles: game.objects.author_profiles.map(&:url),
      author: game.author,
      episode: game.seriesnumber,
      series: game.seriesname,
      genre: game.genre,
      published_year: game.published.to_date.year,
      website: game.website.url,
      ratings_average: game.ratings.meta.average,
      ratings: game.ratings.url,
      ratings_count: game.ratings.meta[:count],
      desc: game.desc,
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
      # TODO: awards
      # TODO: external reviews
      # TODO: tags
      # TODO: rating_histogram
      member_reviews_count: game.links.member_reviews.meta[:count],
      member_reviews: game.objects.member_reviews.map do |review|
        {
          # TODO: votes
          rating: review.try(:rating),
          summary: review.summary,
          moddate: review.moddate.to_date.to_s,
          reviewer: {
            name: review.objects.reviewer.name,
            location: review.objects.reviewer.try(:location)
          },
          # TODO: tags
          review: review.review
          # TODO: comments_count
        }
      end,
      # TODO: links
      # TODO: editor url/name
      # TODO: version/history links
      download_notes: game.downloadnotes,
      download_links: game.objects.download_links.map do |link|
        {
          display_order: link.displayorder,
          file: link.file.url,
          title: link.title,
          desc: link.try(:desc),
          # TODO: format, os, os_version
          # TODO: compression, compressed_primary
          # TODO: attrs
        }
      end,
      players: game.players.url,
      players_count: game.players.meta[:count],
      wishlists: game.wishlists.url,
      wishlists_count: game.wishlists.meta[:count]
    }
    max_id = games(:maximal).id
    expected = {
      coverart: 'http://ifdb.tads.org/viewgame?coverart&id=38iqpon2ekeryjcs&ldesc',
      large_thumbnail: 'http://ifdb.tads.org/viewgame?coverart&id=38iqpon2ekeryjcs&thumbnail=175x175',
      title: 'Max Blaster and Doris de Lightning Against the Parrot Creatures of Venus',
      author_profiles: ["http://www.example.com/members/#{members(:arthur).id}",
                        "http://www.example.com/members/#{members(:trillian).id}"],
      author: 'Dan Shiovitz and Emily Short',
      episode: '1',
      series: 'Max Blaster',
      genre: 'Superhero/Espionage/Humor/Science Fiction',
      published_year: 2003,
      website: 'http://example.com/max',
      ratings_average: 3.3333333333333335,
      ratings: "http://www.example.com/games/#{max_id}/ratings",
      ratings_count: 3,
      desc: 'Someplace on Venus a secret weapon is being built that threatens Earth with total destruction. ' \
            "You and your comrade must penetrate the Xavian base and save the world -- before it's too late!",
      language: 'en-US, de, pt-BR',
      language_names: { 'en-US': 'English', 'de': 'German', 'pt-BR': 'Portuguese' },
      published: '2003-01-01T00:00:00.000Z',
      version: '1.0',
      license: 'Freeware',
      system: 'TADS 3',
      bafsid: 2096,
      forgiveness: 'Polite',
      ifids: [ifids(:max1).to_s, ifids(:max2).to_s],
      tuid: max_id,
      member_reviews_count: 2,
      member_reviews: [
        {
          rating: 3,
          summary: 'Not bad',
          moddate: '2016-02-23',
          reviewer: {
            name: 'Arthur Dent',
            location: 'Cottington, England, Earth'
          },
          review: 'This is a decent game.'
        },
        {
          rating: nil,
          summary: 'Difficult',
          moddate: '2016-03-04',
          reviewer: {
            name: 'Tricia McMillan',
            location: nil
          },
          review: 'I got stuck and never finished.'
        }
      ],
      download_notes: "To play, you'll need a TADS 3 Interpreter - visit tads.org for interpreter downloads.",
      download_links: [
        {
          display_order: 1,
          file: 'http://www.ifarchive.org/if-archive/games/springthing/2003/parrots/parrots.t3',
          title: 'parrots.t3',
          desc: nil
        },
        {
          display_order: 2,
          file: 'http://www.ifarchive.org/if-archive/games/springthing/2003/parrots/README.txt',
          title: 'README.txt',
          desc: 'some setup help'
        }
      ],
      players: "http://www.example.com/games/#{max_id}/players",
      players_count: 2,
      wishlists: "http://www.example.com/games/#{max_id}/wishlists",
      wishlists_count: 1
    }
    assert_equal expected, vals
  end

  # TODO: whoselist page

  test 'fetch all data for the ratings page' do
    game = ifdb.games.last.data.last.self(include: 'ratings.reviewer').get
    vals = {
      # TODO: sort links?
      # TODO: pagination?
      reviews_and_ratings: game.objects.ratings.map do |review|
        {
          # TODO: review votes
          rating: review.rating,
          summary: review.try(:summary),
          date: review.moddate,
          reviewer: {
            link: review.reviewer.url,
            name: review.objects.reviewer.name,
            location: review.objects.reviewer.try(:location),
          },
          # TODO: review tags
          review: review.try(:review)
          # TODO: review comments
        }
      end
    }
    expected = {
      reviews_and_ratings: [
        {
          rating: 3,
          summary: nil,
          date: '2017-01-04T00:00:00.000Z',
          reviewer: {
            link: "http://www.example.com/members/#{members(:maximal).id}",
            name: 'Peter Molydeux',
            location: 'Twitter'
          },
          review: nil
        },
        {
          rating: 4,
          summary: nil,
          date: '2017-01-03T00:00:00.000Z',
          reviewer: {
            link: "http://www.example.com/members/#{members(:minimal).id}",
            name: 'Minny Malle',
            location: nil
          },
          review: nil
        },
        {
          rating: 3,
          summary: 'Not bad',
          date: '2016-02-23T00:00:00.000Z',
          reviewer: {
            link: "http://www.example.com/members/#{members(:arthur).id}",
            name: 'Arthur Dent',
            location: 'Cottington, England, Earth'
          },
          review: 'This is a decent game.'
        }
        # TODO: external review
      ]
    }
    assert_equal expected, vals
  end

  test 'follow the ratings link' do
    ratings = ifdb.games.last.data.last.ratings.get
    assert_equal [3, 4, 3], ratings.map(&:rating)
  end

  # TODO: member-reviews page

  # TODO: fetch a review
  # TODO: fetch a reviewer

  test 'follow the download-links link' do
    game_links = ifdb.games.last.data.last.download_links.get
    assert_equal ['parrots.t3', 'README.txt'], game_links.map(&:title)
  end

  test 'fetch a game-link resource' do
    game_link = ifdb.games.last.data.last.download_links.first.self.get
    assert_equal 'parrots.t3', game_link.title
  end
end
