require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'hal renderer' do
    class TestModel
      def to_hal
        'foo'
      end
    end

    class TestsController < ApplicationController
      def show
        render hal: TestModel.new
      end
    end

    begin
      Rails.application.routes.draw do
        get 'foo', to: 'application_controller_test/tests#show'
      end
      get '/foo'
      assert_response :success
      assert_equal 'application/hal+json', @response.content_type
      assert_equal 'foo', @response.body
    ensure
      Rails.application.routes_reloader.reload!
    end
  end
end
