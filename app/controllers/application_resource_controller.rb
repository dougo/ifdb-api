class ApplicationResourceController < ApplicationController
  include JSONAPI::ActsAsResourceController

  private

  def resource_serializer_klass
    ApplicationResource::Serializer
  end
end
