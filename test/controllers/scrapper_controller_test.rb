require 'test_helper'

class ScrapperControllerTest < ActionDispatch::IntegrationTest
  test "should get run" do
    get scrapper_run_url
    assert_response :success
  end

end
