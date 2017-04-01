require 'test_helper'
require 'minitest/mock'

class ApplicationResourceControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes ApplicationResourceController, JSONAPI::ActsAsResourceController
  end

  class TestResource < ApplicationResource
    def self.find_by_key(key, options = {})
    end

    class Serializer < superclass::Serializer
    end
  end

  class TestController < ApplicationResourceController
  end

  test 'resource_serializer_klass' do
    mock = Minitest::Mock.new
    TestResource::Serializer.stub(:new, mock) do
      mock.expect(:serialize_to_hash, {}, [nil])

      begin
        Rails.application.routes.draw do
          get 'foo', to: 'application_resource_controller_test/test#show'
        end
        get '/foo'
        assert_response :success
        mock.verify
      ensure
        Rails.application.routes_reloader.reload!
      end
    end
  end
end
