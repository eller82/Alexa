require 'test_helper'

class AlexaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get alexa_index_url
    assert_response :success
  end

end
