require "test_helper"

class Public::LinksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_links_new_url
    assert_response :success
  end
end
