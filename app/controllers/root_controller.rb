class RootController < ApplicationController
  include JSONAPI::ActsAsResourceController

  def index
    return unless verify_accept_header
    json = {
      meta: {},
      links: {
        self: root_url,
        games: games_url,
        members: members_url
      }
    }
    render json: json, content_type: JSONAPI::MEDIA_TYPE
  end
end
