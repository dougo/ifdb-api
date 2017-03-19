require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  test_extends ApplicationController

  test 'JSONAPI' do
    assert_includes MembersController, JSONAPI::ActsAsResourceController
  end
end
