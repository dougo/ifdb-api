class GamesController < ApplicationController
  def show
    @model = Game.find(params[:id])
    yaks = Yaks.new
    render json: yaks.call(@model)
  end
end
