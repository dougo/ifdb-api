class GamesController < ApplicationResourceController
  def show
    fwd = GameForward.find_by(gameid: params[:id])
    if fwd
      redirect_to id: fwd.fwdgameid, status: :moved_permanently
    else
      super
    end
  end
end
