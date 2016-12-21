class GamesController < ApplicationController
  def show
    @model = Game.find(params[:id])
    render json: @model
  end
end
