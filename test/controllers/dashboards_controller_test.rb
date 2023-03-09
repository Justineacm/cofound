require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get preview" do
    get dashboards_preview_url
    assert_response :success
  end

  test "should get toto" do
    get dashboards_toto_url
    assert_response :success
  end
end
