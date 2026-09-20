require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "debe mostrar el formulario de inicio de sesion" do
    get login_url

    assert_response :success
  end
end
