class SessionsController < ApplicationController
  def new
  end

  def create
    usuario = Usuario.find_by(email: params[:email])

    if usuario&.authenticate(params[:password])
      if usuario.activo?
        session[:usuario_id] = usuario.id

        redirect_to root_path,
                    notice: "Inicio de sesión exitoso."
      else
        flash.now[:alert] = "Esta cuenta se encuentra desactivada."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Correo o contraseña incorrectos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:usuario_id)

    redirect_to login_path, notice: "Sesión cerrada correctamente."
  end
end