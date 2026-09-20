class UsuariosController < ApplicationController
  before_action :redirigir_si_autenticado, only: [:new, :create]

  before_action :requerir_autenticacion,
                only: [
                  :index,
                  :nuevo_administrativo,
                  :crear_administrativo,
                  :edit,
                  :update,
                  :cambiar_estado
                ]

  before_action :requerir_administrador,
                only: [
                  :index,
                  :nuevo_administrativo,
                  :crear_administrativo,
                  :edit,
                  :update,
                  :cambiar_estado
                ]

  def new
    @usuario = Usuario.new
  end

  # Registro público
  def create
    @usuario = Usuario.new(usuario_params)

    @usuario.rol = "usuario"
    @usuario.activo = false

    if @usuario.save
      redirect_to login_path,
                  notice: "Tu solicitud de acceso fue registrada correctamente. Un administrador debe aprobar tu cuenta antes de que puedas iniciar sesión."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Administración de usuarios
  def index
    @usuarios = Usuario.order(:apellido, :nombre)
  end

  def nuevo_administrativo
    @usuario = Usuario.new
  end

  def crear_administrativo
    @usuario = Usuario.new(usuario_administrativo_params)
    @usuario.activo = true

    unless %w[usuario administrador].include?(@usuario.rol)
      @usuario.errors.add(:rol, "no es válido")

      render :nuevo_administrativo,
             status: :unprocessable_entity
      return
    end

    if @usuario.save
      redirect_to administrar_usuarios_path,
                  notice: "El usuario fue creado correctamente."
    else
      render :nuevo_administrativo,
             status: :unprocessable_entity
    end
  end

  def edit
    @usuario = Usuario.find(params[:id])
  end

  def update
    @usuario = Usuario.find(params[:id])

    if @usuario == current_usuario
      redirect_to administrar_usuarios_path,
                  alert: "No puedes modificar el rol de tu propia cuenta."
      return
    end

    if @usuario.demo?
      redirect_to administrar_usuarios_path,
                  alert: "La cuenta demo está protegida."
      return
    end

    nuevo_rol = params.dig(:usuario, :rol)

    unless %w[usuario administrador].include?(nuevo_rol)
      redirect_to editar_usuario_path(@usuario),
                  alert: "El rol seleccionado no es válido."
      return
    end

    if @usuario.administrador? &&
       nuevo_rol == "usuario" &&
       @usuario.activo? &&
       ultimo_administrador_activo?

      redirect_to administrar_usuarios_path,
                  alert: "No puedes cambiar el rol del último administrador activo."
      return
    end

    if @usuario.update(rol: nuevo_rol)
      redirect_to administrar_usuarios_path,
                  notice: "El rol del usuario fue actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cambiar_estado
    @usuario = Usuario.find(params[:id])

    if @usuario == current_usuario
      redirect_to administrar_usuarios_path,
                  alert: "No puedes desactivar tu propia cuenta."
      return
    end

    if @usuario.demo?
      redirect_to administrar_usuarios_path,
                  alert: "La cuenta demo está protegida."
      return
    end

    nuevo_estado = !@usuario.activo?

    if @usuario.administrador? &&
       @usuario.activo? &&
       !nuevo_estado &&
       ultimo_administrador_activo?

      redirect_to administrar_usuarios_path,
                  alert: "No puedes desactivar al último administrador activo."
      return
    end

    if @usuario.update(activo: nuevo_estado)
      mensaje =
        if nuevo_estado
          "El usuario fue activado correctamente."
        else
          "El usuario fue desactivado correctamente."
        end

      redirect_to administrar_usuarios_path,
                  notice: mensaje
    else
      redirect_to administrar_usuarios_path,
                  alert: "No se pudo cambiar el estado del usuario."
    end
  end

  private

  def ultimo_administrador_activo?
    Usuario.where(
      rol: "administrador",
      activo: true
    ).count <= 1
  end

  def requerir_administrador
    return if current_usuario&.administrador?

    redirect_to root_path,
                alert: "No tienes permisos para acceder a esta sección."
  end

  # Parámetros permitidos para registro público.
  # El visitante no puede enviar rol ni estado.
  def usuario_params
    params.require(:usuario).permit(
      :nombre,
      :apellido,
      :email,
      :password,
      :password_confirmation
    )
  end

  # Parámetros permitidos para creación administrativa.
  def usuario_administrativo_params
    params.require(:usuario).permit(
      :nombre,
      :apellido,
      :email,
      :password,
      :password_confirmation,
      :rol
    )
  end

  def redirigir_si_autenticado
    return unless usuario_autenticado?

    redirect_to root_path,
                alert: "Ya tienes una sesión iniciada."
  end
end