require "test_helper"

class Public::MultiCreatesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_multi_creates_new_url
    assert_response :success
  end
end
