require "test_helper"

class InicioControllerTest < ActionDispatch::IntegrationTest
  test "debe requerir autenticacion" do
    get root_url

    assert_redirected_to login_url
  end
end