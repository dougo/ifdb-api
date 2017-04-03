class GameLinkResource < ApplicationResource
  compound_id %i(gameid displayorder)

  attributes *%i(displayorder title desc)

  def custom_links(options)
    { file: _model.url }
  end
end
