HyperResource::Adapter::JSON_API.concern :Testing do
  include HyperResource::Testing

  def new_jsonapi_hyper_resource
    HyperResource.new(root: "http://#{host}",
                      adapter: HyperResource::Adapter::JSON_API,
                      headers: { 'Accept' => 'application/vnd.api+json' })
  end

  class_methods do
    def test(*args, &block)
      super(*args) do
        begin
          instance_eval &block
        rescue HyperResource::ServerError => e
          err = e.body[:errors][0][:meta]
          e = e.class.new(err[:exception], cause: e.cause, response: e.response, body: e.body)
          e.set_backtrace(err[:backtrace])
          raise e
        end
      end
    end
  end
end
