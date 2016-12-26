class SchemasController < ApplicationController
  def show
    schema = (params[:resource] + '_schema').camelize.constantize.new.schema
    schema[:id] = schema_url(params[:resource])
    render json: JSON.pretty_generate(schema)
  end
end
