require 'test_helper'

class FetchMembersTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  test 'fetch all data needed by the members index page' do
    members = ifdb.members.get
    vals = {
      members: members.first(2).map do |member|
        {
          thumbnail: member.try(:thumbnail)&.url,
          url: member.url,
          name: member.name,
          location: member.try(:location),
          since: member.since,
          profile_summary: member.try(:profile_summary)
        }
      end,
      pages: {
        first: members.links[:first].url,
        prev: members.try(:prev)&.url,
        next: members.try(:next)&.url,
        last: members.last.url
      }
    }
    expected = {
      members: [
        {
          thumbnail: nil,
          url: "http://www.example.com/members/#{members(:minimal).id}",
          name: 'Minny Malle',
          location: nil,
          since: '2017-03-23T00:00:00.000Z',
          profile_summary: nil
        },
        {
          thumbnail: 'http://ifdb.tads.org/showuser?id=lh77sr5f9w0ezc5z&pic&thumbnail=80x80',
          url: "http://www.example.com/members/#{members(:maximal).id}",
          name: 'Peter Molydeux',
          location: 'Twitter',
          since: '2017-03-22T00:00:00.000Z',
          profile_summary: 'Imagine a game where every now and again the game pauses, ' \
                           'whilst all NPCs gather to decide if to res...'
        }
      ],
      pages: {
        first: 'http://www.example.com/members?page%5Bnumber%5D=1&page%5Bsize%5D=20',
        prev: nil,
        next: 'http://www.example.com/members?page%5Bnumber%5D=2&page%5Bsize%5D=20',
        last: 'http://www.example.com/members?page%5Bnumber%5D=6&page%5Bsize%5D=20'
      }
    }
    assert_equal expected, vals
  end

  test 'fetch all data needed by the member profile page' do
    member = ifdb.members[1].self(include: 'played-games,wishlist,not-interested').get
    vals = {
      picture: member.picture.url,
      large_thumbnail: member.large_thumbnail.url,
      name: member.name,
      location: member.location,
      # TODO: top-50 reviewer?
      since: member.since,
      # TODO: last visited?
      tuid: member.id,
      public_email: member.publicemail,
      # TODO: comments
      # TODO: games
      # TODO: lists
      # TODO: polls
      # TODO: reviews
      # TODO: page[size]=5 for these three play lists:
      played_games: member.objects.played_games.map     { |g| { title: g.title, author: g.author } },
      wishlist: member.objects.wishlist.map             { |g| { title: g.title, author: g.author } },
      not_interested: member.objects.not_interested.map { |g| { title: g.title, author: g.author } },
      # TODO: club memberships
    }
    expected = {
      picture: 'http://ifdb.tads.org/showuser?id=lh77sr5f9w0ezc5z&ldesc&pic',
      large_thumbnail: 'http://ifdb.tads.org/showuser?id=lh77sr5f9w0ezc5z&pic&thumbnail=250x250',
      name: 'Peter Molydeux',
      location: 'Twitter',
      since: '2017-03-22T00:00:00.000Z',
      tuid: members(:maximal).id,
      public_email: 'petermolydeux@twitter.com',
      played_games: [
        {
          title: 'Max Blaster and Doris de Lightning Against the Parrot Creatures of Venus',
          author: 'Dan Shiovitz and Emily Short'
        }
      ],
      wishlist: [
        {
          title: 'Zork',
          author: 'Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling'
        },
        {
          title: 'The Minimalist',
          author: 'Mark Cook'
        }
      ],
      not_interested: [
        {
          title: 'Adventure',
          author: 'Will Crowther'
        }
      ],
    }
    assert_equal expected, vals
  end

  # TODO: playlist page
  # TODO: wishlist page
  # TODO: unwishlist page
end
