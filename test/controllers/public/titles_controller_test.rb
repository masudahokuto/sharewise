require "test_helper"

class Public::TitlesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_titles_new_url
    assert_response :success
  end
end
