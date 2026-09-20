class InicioController < ApplicationController
  before_action :requerir_autenticacion

  def index
    @total_libros = Libro.count

    @total_leidos = current_usuario.lecturas.where(estado: "leido").count
    @total_en_proceso = current_usuario.lecturas.where(estado: "en_proceso").count
    @total_pendientes = current_usuario.lecturas.where(estado: "pendiente").count
  end
end