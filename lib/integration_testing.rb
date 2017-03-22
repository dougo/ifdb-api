concern :IntegrationTesting do
  include HyperResource::Adapter::JSON_API::Testing

  def ifdb
    @ifdb ||= new_jsonapi_hyper_resource
  end
end
