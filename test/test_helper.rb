ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Ejecuta los tests en paralelo cuando la cantidad de pruebas lo amerita
    parallelize(workers: :number_of_processors)

    # Las fixtures se cargarán únicamente en los tests que las necesiten

    # Métodos auxiliares para los tests pueden agregarse aquí
  end
end