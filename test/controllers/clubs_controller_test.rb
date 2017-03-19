require 'test_helper'

class ClubsControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes ClubsController, JSONAPI::ActsAsResourceController
  end
end
