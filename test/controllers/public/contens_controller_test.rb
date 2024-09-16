require "test_helper"

class Public::ContensControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_contens_new_url
    assert_response :success
  end

  test "should get show" do
    get public_contens_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_contens_edit_url
    assert_response :success
  end
end
