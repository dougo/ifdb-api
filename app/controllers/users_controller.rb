class UsersController < ApplicationController
  def show
    render hal: User.find(params[:id])
  end
end
