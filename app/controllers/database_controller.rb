class DatabaseController < ApplicationResourceController
  private

  def resource_serializer_klass
    DatabaseResource::Serializer
  end
end
