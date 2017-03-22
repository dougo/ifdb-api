HyperResource::Adapter::JSON_API.concern :Testing do
  include HyperResource::Testing

  def new_jsonapi_hyper_resource
    HyperResource.new(root: "http://#{host}",
                      adapter: HyperResource::Adapter::JSON_API,
                      headers: { 'Accept' => 'application/vnd.api+json' })
  end
end
