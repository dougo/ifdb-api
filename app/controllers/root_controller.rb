class RootController < ApplicationController
  include JSONAPI::ActsAsResourceController

  def index
    return unless verify_accept_header
    json = {
      meta: {
        message: 'Welcome to the IFDB API.'
      },
      links: {
        self: root_url,
        games: games_url,
        members: members_url,
        clubs: clubs_url
      }
    }
    render json: json, content_type: JSONAPI::MEDIA_TYPE
  end
end
