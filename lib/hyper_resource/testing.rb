module HyperResource::Testing
  extend ActiveSupport::Concern

  class FaradayAdapter < Faraday::Adapter::Rack
    def initialize(app); super(app, ActionDispatch::IntegrationTest.app) end
    Faraday::Adapter.register_middleware integration_test: self
  end

  included do
    setup do
      @saved_default_adapter = Faraday.default_adapter
      Faraday.default_adapter = :integration_test
    end

    teardown do
      Faraday.default_adapter = @saved_default_adapter
    end
  end
end
