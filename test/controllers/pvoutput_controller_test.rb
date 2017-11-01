require 'test_helper'

class PvoutputControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pvoutput_index_url
    assert_response :success
  end

end
