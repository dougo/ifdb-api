class SchemasController < ApplicationController
  def show
    schema = (params[:resource] + '_schema').camelize.constantize.new.schema
    schema[:id] = schema_url(params[:resource], format: :json)
    render json: schema
  end
end
