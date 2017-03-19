class DatabaseController < ApplicationController
  include JSONAPI::ActsAsResourceController

  def base_response_links
    {
      self: root_url,
      games: games_url,
      members: members_url,
      clubs: clubs_url
    }
  end
end
