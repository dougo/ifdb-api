require 'test_helper'

class ClubMembershipsControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes ClubMembershipsController, JSONAPI::ActsAsResourceController
  end
end
