require 'test_helper'

class FetchClubsTest < ActionDispatch::IntegrationTest
  test 'fetch all data needed by the clubs index page' do
    get root_url, as: :jsonapi
    get response.parsed_body[:links][:clubs], as: :jsonapi, params: {
          include: :memberships,
          fields: { :'club-memberships' => 'id' }
        }
    assert_response :success, -> { response_backtrace }
    prif_id = clubs(:prif).id
    arthur_id = members(:arthur).id
    assert_equal(
      {
        data: [
          {
            id: prif_id,
            type: 'clubs',
            links: {
              # TODO: should be :'web-site'
              web_site: 'http://pr-if.org/',
              self: "http://www.example.com/clubs/#{prif_id}"
            },
            attributes: {
              name: 'PR-IF',
              desc: 'The Boston area IF meetup group.',
              created: '2010-04-10T02:05:19.000Z',
              'members-public': true
            },
            relationships: {
              memberships: {
                links: {
                  self: "http://www.example.com/clubs/#{prif_id}/relationships/memberships",
                  related: "http://www.example.com/clubs/#{prif_id}/memberships"
                },
                # TODO: we only need this for its size; maybe include the size as an attribute on the club?
                data: [ { type: 'club-memberships', id: "#{prif_id}-#{arthur_id}" } ]
              }
            }
          }
        ],
        included: [
          {
            id: "#{prif_id}-#{arthur_id}",
            type: 'club-memberships',
            links: {
              self: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}"
            }
          }
        ],
        links: {
          first: 'http://www.example.com/clubs?fields%5Bclub-memberships%5D=id&include=memberships&page%5Bnumber%5D=1&page%5Bsize%5D=20',
          last:  'http://www.example.com/clubs?fields%5Bclub-memberships%5D=id&include=memberships&page%5Bnumber%5D=1&page%5Bsize%5D=20'
        }
      },
      response.parsed_body)
  end

  test 'fetch all data needed by the club details page' do
    get root_url, as: :jsonapi
    get response.parsed_body[:links][:clubs], as: :jsonapi
    get response.parsed_body[:data].first[:links][:self], as: :jsonapi, params: { include: :memberships }
    assert_response :success, -> { response_backtrace }
    prif_id = clubs(:prif).id
    arthur_id = members(:arthur).id
    assert_equal(
      {
        data: {
          id: prif_id,
          type: 'clubs',
          links: {
            web_site: 'http://pr-if.org/',
            self: "http://www.example.com/clubs/#{prif_id}"
          },
          attributes: {
            name: 'PR-IF',
            desc: 'The Boston area IF meetup group.',
            created: '2010-04-10T02:05:19.000Z',
            'members-public': true
          },
          relationships: {
            memberships: {
              links: {
                self: "http://www.example.com/clubs/#{prif_id}/relationships/memberships",
                related: "http://www.example.com/clubs/#{prif_id}/memberships"
              },
              data: [ { type: 'club-memberships', id: "#{prif_id}-#{arthur_id}" } ]
            }
          }
        },
        included: [
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
                }
              },
              member: {
                links: {
                  self: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}/relationships/member",
                  related: "http://www.example.com/club-memberships/#{prif_id}-#{arthur_id}/member"
                }
              }
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
    get response.parsed_body[:data][:relationships][:memberships][:links][:related], as: :jsonapi, params: {
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
              web_site: 'http://pr-if.org/',
              self: "http://www.example.com/clubs/#{prif_id}"
            },
            attributes: { name: 'PR-IF' }
          },
          {
            id: arthur_id,
            type: 'members',
            links: {
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
          first: "http://www.example.com/clubs/#{prif_id}/memberships?fields%5Bclubs%5D=name&fields%5Bmembers%5D=name%2Clocation%2Ccreated&include=club%2Cmember&page%5Bnumber%5D=1&page%5Bsize%5D=20",
          last:  "http://www.example.com/clubs/#{prif_id}/memberships?fields%5Bclubs%5D=name&fields%5Bmembers%5D=name%2Clocation%2Ccreated&include=club%2Cmember&page%5Bnumber%5D=1&page%5Bsize%5D=20"
        }
      },
      response.parsed_body)
  end

  test 'fetch a club member profile via the membership' do
    get root_url, as: :jsonapi
    get response.parsed_body[:links][:clubs], as: :jsonapi, params: { include: 'memberships.member' }
    document = response.parsed_body
    club = document[:data].first
    included = document[:included]
    linkage = club[:relationships][:memberships][:data].first
    membership = included.find { |resource| resource[:type] == linkage[:type] && resource[:id] == linkage[:id] }
    get membership[:relationships][:member][:links][:related], as: :jsonapi
    assert_response :success, -> { response_backtrace }
    assert_equal 'Arthur Dent', response.parsed_body[:data][:attributes][:name]
  end

  private

  # TODO: move this to JSONAPI::Testing concern
  def response_backtrace
    meta = response.parsed_body[:errors].first[:meta]
    msg = meta[:exception]
    bt = Minitest.backtrace_filter.filter(meta[:backtrace]).join "\n    "
    "#{msg}\n    #{bt}"
  end
end
