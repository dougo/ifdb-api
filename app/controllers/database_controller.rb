class DatabaseController < ApplicationController
  include JSONAPI::ActsAsResourceController

  private

  def resource_serializer_klass
    DatabaseResource::Serializer
  end
end
