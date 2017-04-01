class ApplicationResourceController < ApplicationController
  include JSONAPI::ActsAsResourceController

  private

  def resource_serializer_klass
    resource_klass::Serializer
  end
end
