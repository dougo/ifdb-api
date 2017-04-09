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
          title: 'Adventure',
          author: 'Will Crowther',
          published_year: nil,
          ratings_average: nil
        },
        {
          thumbnail: nil,
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
    game = ifdb.games.last.data.last.self.get
    assert_maximal_game_summary game
    vals = {
      desc: game.desc,
      language: game.language,
      language_names: game.language_names,
      published: game.published,
      version: game.version,
      license: game.license,
      system: game.system,
      bafsid: game.bafsid,
      bafs_guide: game.links.bafs_guide.url,
      forgiveness: game.forgiveness,
      ifids: game.ifids,
      tuid: game.id,
      # TODO: cross references
      # TODO: awards
      editorial_reviews: game.objects.editorial_reviews.map do |review|
        special = review.objects.special_reviewer
        offsite = review.objects.try(:offsite_review)
        reviewer = review.objects.try(:reviewer)
        {
          special_reviewer: {
            display_rank: special.displayrank,
            code: special.code,
            name: special.name
          },
          offsite_review: ({
                             display_order: offsite.displayorder,
                             source: offsite.try(:source)&.url,
                             source_name: offsite.sourcename,
                             full_review: offsite.full_review.url
                           } if offsite),
          reviewer: ({
                       name: reviewer.name,
                       location: reviewer.try(:location)
                     } if reviewer),
          rating: review.try(:rating),
          summary: review.try(:summary),
          review: review.review
          # TODO: comments_count
        }
      end,
      # TODO: tags
      # TODO: rating_histogram
      member_reviews_count: game.links.member_reviews.meta[:count],
      member_reviews: game.objects.member_reviews.map do |review|
        reviewer = review.objects.reviewer
        {
          # TODO: votes
          rating: review.try(:rating),
          summary: review.summary,
          moddate: review.moddate.to_date.to_s,
          reviewer: {
            name: reviewer.name,
            location: reviewer.try(:location)
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
      desc: 'Someplace on Venus a secret weapon is being built that threatens Earth with total destruction. ' \
            "You and your comrade must penetrate the Xavian base and save the world -- before it's too late!",
      language: 'en-US, de, pt-BR',
      language_names: { 'en-US': 'English', 'de': 'German', 'pt-BR': 'Portuguese' },
      published: '2003-01-01T00:00:00.000Z',
      version: '1.0',
      license: 'Freeware',
      system: 'TADS 3',
      bafsid: 2096,
      bafs_guide: 'http://www.wurb.com/if/game/2096',
      forgiveness: 'Polite',
      ifids: [ifids(:max1).to_s, ifids(:max2).to_s],
      tuid: max_id,
      editorial_reviews: [
        {
          special_reviewer: {
            display_rank: 10,
            code: 'bafs',
            name: "Baf's Guide"
          },
          offsite_review: nil,
          reviewer: nil,
          rating: nil,
          summary: nil,
          review: 'At the delcot of tondam, where doshes deave.'
        },
        {
          special_reviewer: {
            display_rank: 50,
            code: 'external',
            name: 'External'
          },
          offsite_review: {
            display_order: 0,
            source: 'http://www.spagmag.org',
            source_name: 'SPAG',
            full_review: 'http://www.spagmag.org/archives/m.html#max'
          },
          reviewer: nil,
          rating: 3,
          summary: 'This is space opera, in sexy pants.',
          review: 'In the end the bugs wore me down and I come away from the game somewhat dissatisfied...',
        },
        {
          special_reviewer: {
            display_rank: 50,
            code: 'external',
            name: 'External'
          },
          offsite_review: {
            display_order: 1,
            source: nil,
            source_name: 'Home of the Underdogs',
            full_review: 'http://homeoftheunderdogs.net/game.php?id=4473'
          },
          reviewer: nil,
          rating: nil,
          summary: nil,
          review: 'Two thumbs up!'
        },
        {
          special_reviewer: {
            display_rank: 100,
            code: 'author',
            name: 'From the Author'
          },
          offsite_review: nil,
          reviewer: {
            name: 'Peter Molydeux',
            location: 'Twitter'
          },
          rating: nil,
          summary: nil,
          review: 'My best work.'
        }
      ],
      member_reviews_count: 2,
      member_reviews: [
        {
          rating: nil,
          summary: 'Difficult',
          moddate: '2016-03-04',
          reviewer: {
            name: 'Tricia McMillan',
            location: nil
          },
          review: 'I got stuck and never finished.'
        },
        {
          rating: 3,
          summary: 'Not bad',
          moddate: '2016-02-23',
          reviewer: {
            name: 'Arthur Dent',
            location: 'Cottington, England, Earth'
          },
          review: 'This is a decent game.'
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
    reviews_and_ratings = ifdb.games.last.data.last.links.ratings.get
    assert_maximal_game_summary reviews_and_ratings.first.objects.game
    vals = {
      # TODO: sort links?
      # TODO: pagination?
      reviews_and_ratings: reviews_and_ratings.map do |review|
        {
          # TODO: review votes
          rating: review.rating,
          summary: review.try(:summary),
          date: review.moddate,
          reviewer: ({
            name: review.objects.reviewer.name,
            location: review.objects.reviewer.try(:location),
          } if review.objects.try(:reviewer)),
          # TODO: review tags
          review: review.try(:review)
          # TODO: review comments count & link
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
            name: 'Arthur Dent',
            location: 'Cottington, England, Earth'
          },
          review: 'This is a decent game.'
        },
        {
          rating: 3,
          summary: 'This is space opera, in sexy pants.',
          date: '2004-09-28T00:00:00.000Z',
          reviewer: nil,
          # TODO: special_reviewer/offsite_review
          review: 'In the end the bugs wore me down and I come away from the game somewhat dissatisfied...',
        }
      ]
    }
    assert_equal expected, vals
  end

  test 'fetch all data for the member-reviews page' do
    member_reviews = ifdb.games.last.data.last.links.member_reviews.get
    assert_maximal_game_summary member_reviews.first.objects.game
    vals = {
      # TODO: sort links?
      # TODO: pagination?
      member_reviews: member_reviews.map do |review|
        {
          # TODO: review votes
          rating: review.try(:rating),
          summary: review.summary,
          date: review.moddate,
          reviewer: {
            name: review.objects.reviewer.name,
            location: review.objects.reviewer.try(:location),
          },
          # TODO: review tags
          review: review.review
          # TODO: review comments count & link
        }
      end
    }
    expected = {
      member_reviews: [
        {
          rating: nil,
          summary: 'Difficult',
          date: '2016-03-04T00:00:00.000Z',
          reviewer: {
            name: 'Tricia McMillan',
            location: nil
          },
          review: 'I got stuck and never finished.'
        },
        {
          rating: 3,
          summary: 'Not bad',
          date: '2016-02-23T00:00:00.000Z',
          reviewer: {
            name: 'Arthur Dent',
            location: 'Cottington, England, Earth'
          },
          review: 'This is a decent game.'
        }
      ]
    }
    assert_equal expected, vals
  end

  # TODO: fetch review comments page
  # TODO: follow review comments link

  test 'fetch a review resource' do
    review = ifdb.games.last.data.last.ratings.first.self.get
    assert_equal 3, review.rating
  end

  test 'fetch a reviewer' do
    reviewer = ifdb.games.last.data.last.ratings.first.reviewer.get
    assert_equal 'Peter Molydeux', reviewer.name
  end

  test 'follow the download-links link' do
    game_links = ifdb.games.last.data.last.download_links.get
    assert_equal ['parrots.t3', 'README.txt'], game_links.map(&:title)
  end

  test 'fetch a game-link resource' do
    game_link = ifdb.games.last.data.last.download_links.first.self.get
    assert_equal 'parrots.t3', game_link.title
  end

  private

  def assert_maximal_game_summary(game)
    vals = {
      coverart: game.coverart.url,
      large_thumbnail: game.large_thumbnail.url,
      title: game.title,
      author_ids: game.objects.author_profiles.map(&:id),
      author: game.author,
      episode: game.seriesnumber,
      series: game.seriesname,
      genre: game.genre,
      published_year: game.published.to_date.year,
      website: game.website.url,
      ratings_average: game.ratings.meta.average,
      ratings_count: game.ratings.meta[:count]
    }
    expected = {
      coverart: 'http://ifdb.tads.org/viewgame?coverart&id=38iqpon2ekeryjcs&ldesc',
      large_thumbnail: 'http://ifdb.tads.org/viewgame?coverart&id=38iqpon2ekeryjcs&thumbnail=175x175',
      title: 'Max Blaster and Doris de Lightning Against the Parrot Creatures of Venus',
      author_ids: members(:arthur, :trillian).map(&:id),
      author: 'Dan Shiovitz and Emily Short',
      episode: '1',
      series: 'Max Blaster',
      genre: 'Superhero/Espionage/Humor/Science Fiction',
      published_year: 2003,
      website: 'http://example.com/max',
      ratings_average: 3.25,
      ratings_count: 4,
    }
    assert_equal expected, vals
  end
end
