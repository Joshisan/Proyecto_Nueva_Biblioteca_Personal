class LecturasController < ApplicationController
  before_action :requerir_autenticacion

  def index
    @estado = params[:estado]

    lecturas = current_usuario.lecturas
                              .includes(libro: :categoria)
                              .joins(:libro)
                              .where(libros: { activo: true })

    if %w[pendiente en_proceso leido].include?(@estado)
      lecturas = lecturas.where(estado: @estado)
    else
      @estado = nil
    end

    @lecturas = lecturas.order(updated_at: :desc)

    @total_lecturas = current_usuario.lecturas
                                     .joins(:libro)
                                     .where(libros: { activo: true })
                                     .count

    @total_pendientes = current_usuario.lecturas
                                       .joins(:libro)
                                       .where(libros: { activo: true })
                                       .where(estado: "pendiente")
                                       .count

    @total_en_proceso = current_usuario.lecturas
                                       .joins(:libro)
                                       .where(libros: { activo: true })
                                       .where(estado: "en_proceso")
                                       .count

    @total_leidos = current_usuario.lecturas
                                   .joins(:libro)
                                   .where(libros: { activo: true })
                                   .where(estado: "leido")
                                   .count
  end

  def create
    if current_usuario.demo?
      redirect_to libro_path(params[:libro_id]),
                  alert: "El usuario demo es de solo lectura."
      return
    end

    libro = Libro.find(params[:libro_id])

    unless libro.activo?
      redirect_to libros_path,
                  alert: "Este libro no se encuentra disponible en el catálogo."
      return
    end

    lectura = current_usuario.lecturas.find_or_initialize_by(libro: libro)

    lectura.estado = params[:estado]
    lectura.notas = params[:notas]

    if lectura.save
      redirect_to libro_path(libro),
                  notice: "Tu lectura se actualizó correctamente."
    else
      redirect_to libro_path(libro),
                  alert: "No se pudo actualizar la lectura."
    end
  end

  def destroy
    if current_usuario.demo?
      redirect_to mi_biblioteca_path,
                  alert: "El usuario demo es de solo lectura."
      return
    end

    lectura = current_usuario.lecturas.find_by(libro_id: params[:libro_id])

    if lectura.present?
      lectura.destroy

      redirect_to mi_biblioteca_path,
                  notice: "El libro fue eliminado de tu biblioteca."
    else
      redirect_to mi_biblioteca_path,
                  alert: "No se encontró la lectura que deseas eliminar."
    end
  end
end