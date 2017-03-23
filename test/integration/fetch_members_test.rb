require 'test_helper'

class FetchMembersTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  test 'fetch all data needed by the members index page' do
    members = ifdb.members
    vals = {
      members: members.first(2).map do |member|
        {
          thumbnail: member.links[:thumbnail]&.url,
          url: member.url,
          name: member.name,
          location: member.attributes[:location],
          since: member.since,
          profile_summary: member.attributes[:profile_summary]
        }
      end,
      pages: {
        first: members.links[:first].url,
        prev: members.links[:prev]&.url,
        next: members.links[:next]&.url,
        last: members.links[:last].url
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
          thumbnail: 'http://ifdb.tads.org/showimage?id=4%3A701&thumbnail=80x80',
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
end
