require 'test_helper'

class PrintToolsControllerTest < ActionController::TestCase
  test "should get print" do
    get :print
    assert_response :success
  end

  test "should get admin" do
    get :admin
    assert_response :success
  end

end
