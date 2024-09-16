require "test_helper"

class Public::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_categories_new_url
    assert_response :success
  end
end
