class LibrosController < ApplicationController
  before_action :requerir_autenticacion

  before_action :requerir_administrador,
                only: [
                  :new,
                  :create,
                  :edit,
                  :update,
                  :archivar,
                  :restaurar,
                  :archivados
                ]

  def index
    @vista = %w[cuadricula lista].include?(params[:vista]) ? params[:vista] : "cuadricula"

    libros = Libro.where(activo: true).includes(:categoria)

    if params[:buscar].present?
      termino = "%#{params[:buscar]}%"

      libros = libros
        .joins(:categoria)
        .where(
          "libros.titulo ILIKE :termino OR
          libros.autor ILIKE :termino OR
          libros.editorial ILIKE :termino OR
          categorias.nombre ILIKE :termino",
          termino: termino
        )
    end

    libros = libros.order(:titulo)

    @total_libros = libros.count
    @pagy, @libros = pagy(:offset, libros, limit: 24)
  end

  def archivados
    @libros = Libro.where(activo: false)
                   .includes(:categoria)
                   .order(:titulo)
  end

  def show
    @libro = Libro.find(params[:id])

    if !@libro.activo? && !current_usuario.administrador?
      redirect_to libros_path,
                  alert: "Este libro no se encuentra disponible en el catálogo."
      return
    end

    @lectura = current_usuario.lecturas.find_by(libro: @libro)
  end

  def new
    @libro = Libro.new
    @categorias = Categoria.order(:nombre)
  end

  def create
    @libro = Libro.new(libro_params)

    if @libro.save
      redirect_to libro_path(@libro),
                  notice: "El libro fue agregado correctamente."
    else
      @categorias = Categoria.order(:nombre)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @libro = Libro.find(params[:id])
    @categorias = Categoria.order(:nombre)
  end

  def update
    @libro = Libro.find(params[:id])

    if @libro.update(libro_params)
      redirect_to libro_path(@libro),
                  notice: "El libro fue actualizado correctamente."
    else
      @categorias = Categoria.order(:nombre)
      render :edit, status: :unprocessable_entity
    end
  end

  def archivar
    @libro = Libro.find(params[:id])
    @libro.update!(activo: false)

    redirect_to libros_path,
                notice: "El libro fue archivado correctamente."
  end

  def restaurar
    @libro = Libro.find(params[:id])
    @libro.update!(activo: true)

    redirect_to libro_path(@libro),
                notice: "El libro fue restaurado correctamente."
  end

  private

  def libro_params
    params.require(:libro).permit(
      :isbn,
      :titulo,
      :autor,
      :categoria_id,
      :anio_publicacion,
      :anio_edicion,
      :idioma,
      :editorial,
      :unidades,
      :portada_url
    )
  end

  def requerir_administrador
    return if current_usuario&.administrador?

    redirect_to libros_path,
                alert: "No tienes permisos para realizar esta acción."
  end
end