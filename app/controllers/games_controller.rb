class GamesController < ApplicationController
  include JSONAPI::ActsAsResourceController

  def show
    fwd = GameForward.find_by(gameid: params[:id])
    if fwd
      redirect_to id: fwd.fwdgameid, status: :moved_permanently
    else
      super
    end
  end

  private

  def resource_serializer_klass
    GameResource::Serializer
  end
end
