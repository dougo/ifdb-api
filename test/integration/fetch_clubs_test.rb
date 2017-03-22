require 'test_helper'

class FetchClubsTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  # TODO: move this to HyperResource::Testing
  def self.test(msg, &block)
    super(msg) do
      begin
        instance_eval(&block)
      rescue HyperResource::ServerError => e
        err = e.body[:errors][0]
        ex = e.class.new(err[:meta][:exception], body: e.body, response: e.response, cause: e.cause)
        ex.set_backtrace(err[:meta][:backtrace])
        raise ex
      end
    end
  end

  test 'fetch all data needed by the clubs index page' do
    clubs = ifdb.clubs
    # TODO: would this be more interesting with a second club?
    club = clubs.first # TODO: fields[clubs]=...
    vals = {
      website: club.website.url,
      name: club.name,
      listed: club.listed,
      members_count: club.members_count,
      desc: club.desc,
    }
    expected = {
      website: 'http://pr-if.org/',
      name: 'PR-IF',
      listed: '2010-04-10T02:05:19.000Z',
      members_count: 1,
      desc: 'The Boston area IF meetup group.',
    }
    assert_equal expected, vals
    assert_equal 'http://www.example.com/clubs?page%5Bnumber%5D=1&page%5Bsize%5D=20', clubs.last.url
    assert_equal clubs.last.url, clubs.links[:first].url
  end

  test 'fetch all data needed by the club details page' do
    arthur_id = members(:arthur).id
    club = ifdb.clubs.first.self(include: 'contact-profiles').get
    vals = {
      name: club.name,
      desc: club.desc,
      listed: club.listed,
      website: club.website.url,
      contacts: club.contacts,
      contact_profiles: club.objects.contact_profiles.first.url,
      members_count: club.members_count
    }
    expected = {
      name: 'PR-IF',
      desc: 'The Boston area IF meetup group.',
      listed: '2010-04-10T02:05:19.000Z',
      website: 'http://pr-if.org/',
      contacts: "Arthur Dent {#{arthur_id}}",
      contact_profiles: "http://www.example.com/members/#{arthur_id}",
      members_count: 1
    }
    assert_equal expected, vals
  end
  
  test 'fetch all data needed by the club members page' do
    arthur_id = members(:arthur).id
    prif_id = clubs(:prif).id
    # TODO: would this be more interesting with a second member?
    # TODO: fields[clubs]=name&fields[members]=name,location
    memberships = ifdb.clubs.first.membership(include: %i(club member)).get
    club = memberships.first.objects.club
    vals = {
      club: { name: club.name, url: club.url },
      members: memberships.map do |membership|
        member = membership.objects.member
        {
          picture: member.picture.url,
          url: member.url,
          name: member.name,
          admin: membership.admin,
          location: member.location,
          joindate: membership.joindate
        }
      end
      # TODO: pagination?
    }
    expected = {
      club: { name: 'PR-IF', url: "http://www.example.com/clubs/#{prif_id}" },
      members: [
        {
          picture: 'http://i.imgur.com/SL9D5td.png',
          url: "http://www.example.com/members/#{arthur_id}",
          name: 'Arthur Dent',
          admin: true,
          location: 'Cottington, England, Earth',
          joindate: '2015-03-15T12:00:00.000Z'
        }
      ]
    }
    assert_equal expected, vals
  end

  test 'fetch a club member profile via the membership' do
    membership = ifdb.clubs(include: 'membership').first.objects.membership.first
    assert_equal 'Arthur Dent', membership.links.member.get.name
  end
end
