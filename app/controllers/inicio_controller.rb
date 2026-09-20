class InicioController < ApplicationController
  before_action :requerir_autenticacion

  def index
    @total_libros = Libro.count

    estados = current_usuario.lecturas.group(:estado).count

    @total_leidos = estados.fetch("leido", 0)
    @total_en_proceso = estados.fetch("en_proceso", 0)
    @total_pendientes = estados.fetch("pendiente", 0)

    @total_lecturas =
      @total_leidos + @total_en_proceso + @total_pendientes

    @porcentaje_leidos = porcentaje(@total_leidos)
    @porcentaje_en_proceso = porcentaje(@total_en_proceso)

    @libros_por_categoria = Categoria
      .joins(:libros)
      .group("categorias.nombre")
      .count
      .sort_by { |nombre, cantidad| [-cantidad, nombre] }

    @maximo_categoria = @libros_por_categoria
      .map(&:last)
      .max || 0
  end

  private

  def porcentaje(cantidad)
    return 0.0 if @total_lecturas.zero?

    cantidad.fdiv(@total_lecturas) * 100
  end
end