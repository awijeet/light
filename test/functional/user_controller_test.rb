require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get likes" do
    get :likes
    assert_response :success
  end

  test "should get friends" do
    get :friends
    assert_response :success
  end

end
