class GamesController < ApplicationController
  def show
    @model = Game.find(params[:id])
    render hal: @model
  end
end
