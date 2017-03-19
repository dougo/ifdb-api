require 'test_helper'

class FetchClubsTest < ActionDispatch::IntegrationTest
  make_my_diffs_pretty!

  class FaradayAdapter < Faraday::Adapter::Rack
    def initialize(app); super(app, FetchClubsTest.app) end
    Faraday::Adapter.register_middleware fetch_clubs_test: self
  end
  Faraday.default_adapter = :fetch_clubs_test

  test 'fetch all data needed by the clubs index page' do
    ifdb = HyperResource.new(root: 'http://www.example.com',
                             adapter: HyperResource::Adapter::JSON_API,
                             headers: { 'Accept' => 'application/vnd.api+json' })

    club = ifdb.clubs.first # TODO: fields[clubs]=...
    expected = {
      website: 'http://pr-if.org/',
      name: 'PR-IF',
      listed: '2010-04-10T02:05:19.000Z',
      members_count: 1,
      desc: 'The Boston area IF meetup group.',
    }
    vals = {
      website: club.website.href,
      name: club.name,
      listed: club.listed,
      members_count: club.public_send('members-count'), # TODO: undasherize keys
      desc: club.desc
    }
    assert_equal expected, vals
    # TODO: pagination links
  end

  test 'fetch all data needed by the club details page' do
    get root_url, as: :jsonapi
    get response.parsed_body[:links][:clubs], as: :jsonapi
    get response.parsed_body[:data].first[:links][:self], as: :jsonapi, params: {
          include: 'contact-profiles', fields: { members: :id }
        }
    assert_response :success, -> { response_backtrace }
    prif_id = clubs(:prif).id
    arthur_id = members(:arthur).id
    assert_equal(
      {
        data: {
          id: prif_id,
          type: 'clubs',
          links: {
            website: 'http://pr-if.org/',
            self: "http://www.example.com/clubs/#{prif_id}"
          },
          attributes: {
            name: 'PR-IF',
            desc: 'The Boston area IF meetup group.',
            contacts: "Arthur Dent {#{arthur_id}}",
            'contacts-plain': 'Arthur Dent',
            'members-public': true,
            'members-count': 1,
            listed: '2010-04-10T02:05:19.000Z'
          },
          relationships: {
            membership: {
              links: {
                self: "http://www.example.com/clubs/#{prif_id}/relationships/membership",
                related: "http://www.example.com/clubs/#{prif_id}/membership"
              }
            },
            'contact-profiles': {
              links: {
                self: "http://www.example.com/clubs/#{prif_id}/relationships/contact-profiles",
                related: "http://www.example.com/clubs/#{prif_id}/contact-profiles"
              },
              data: [ { type: 'members', id: arthur_id } ]
            }
          }
        },
        included: [
          {
            id: arthur_id,
            type: 'members',
            links: {
              picture: 'http://i.imgur.com/SL9D5td.png',
              self: "http://www.example.com/members/#{arthur_id}"
            }
          }
        ]
      },
      response.parsed_body)
  end
  
  test 'fetch all data needed by the club members page' do
    get root_url, as: :jsonapi
    get response.parsed_body[:links][:clubs], as: :jsonapi
    get response.parsed_body[:data].first[:links][:self], as: :jsonapi
    get response.parsed_body[:data][:relationships][:membership][:links][:related], as: :jsonapi, params: {
          include: 'club,member',
          fields: {
            clubs: 'name',
            members: 'name,location,created'
          }
        }
    assert_response :success, -> { response_backtrace }
    prif_id = clubs(:prif).id
    arthur_id = members(:arthur).id
    assert_equal(
      {
        data: [
          {
            id: "#{prif_id}-#{arthur_id}",
            type: 'club-memberships',
            links: {
              self: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}"
            },
            attributes: {
              joindate: '2015-03-15T12:00:00.000Z',
              admin: true
            },
            relationships: {
              club: {
                links: {
                  self: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}/relationships/club",
                  related: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}/club"
                },
                data: { type: 'clubs', id: prif_id }
              },
              member: {
                links: {
                  self: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}/relationships/member",
                  related: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}/member"
                },
                data: { type: 'members', id: arthur_id }
              }
            }
          }
        ],
        included: [
          {
            id: prif_id,
            type: 'clubs',
            links: {
              website: 'http://pr-if.org/',
              self: "http://www.example.com/clubs/#{prif_id}"
            },
            attributes: { name: 'PR-IF' }
          },
          {
            id: arthur_id,
            type: 'members',
            links: {
              picture: 'http://i.imgur.com/SL9D5td.png',
              self: "http://www.example.com/members/#{arthur_id}"
            },
            attributes: {
              name: 'Arthur Dent',
              location: 'Cottington, England, Earth',
              created: members(:arthur).created.as_json
            }
          }
        ],
        links: {
          first: "http://www.example.com/clubs/#{prif_id}/membership?fields%5Bclubs%5D=name&fields%5Bmembers%5D=name%2Clocation%2Ccreated&include=club%2Cmember&page%5Bnumber%5D=1&page%5Bsize%5D=20",
          last:  "http://www.example.com/clubs/#{prif_id}/membership?fields%5Bclubs%5D=name&fields%5Bmembers%5D=name%2Clocation%2Ccreated&include=club%2Cmember&page%5Bnumber%5D=1&page%5Bsize%5D=20"
        }
      },
      response.parsed_body)
  end

  test 'fetch a club member profile via the membership' do
    get root_url, as: :jsonapi
    get response.parsed_body[:links][:clubs], as: :jsonapi, params: { include: 'membership.member' }
    document = response.parsed_body
    club = document[:data].first
    included = document[:included]
    linkage = club[:relationships][:membership][:data].first
    membership = included.find { |resource| resource[:type] == linkage[:type] && resource[:id] == linkage[:id] }
    get membership[:relationships][:member][:links][:related], as: :jsonapi
    assert_response :success, -> { response_backtrace }
    assert_equal 'Arthur Dent', response.parsed_body[:data][:attributes][:name]
  end

  private

  # TODO: move this to JSONAPI::Testing concern
  def response_backtrace
    # TODO: concat multiple errors
    error = response.parsed_body[:errors].first
    # TODO: format using error[:status], error[:code], error[:title], error[:detail]
    meta = error[:meta]
    if meta
      msg = meta[:exception]
      bt = Minitest.backtrace_filter.filter(meta[:backtrace]).join "\n    "
      "#{msg}\n    #{bt}"
    else
      error
    end
  end
end
