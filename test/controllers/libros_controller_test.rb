require "test_helper"

class LibrosControllerTest < ActionDispatch::IntegrationTest
  test "debe requerir autenticacion para ver el catalogo" do
    get libros_url

    assert_redirected_to login_url
  end
end