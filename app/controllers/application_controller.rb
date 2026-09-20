class ApplicationController < ActionController::Base
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_usuario, :usuario_autenticado?

  private

  def current_usuario
    @current_usuario ||= Usuario.find_by(id: session[:usuario_id])
  end

  def usuario_autenticado?
    current_usuario.present?
  end

  def requerir_autenticacion
    return if usuario_autenticado?

    redirect_to login_path, alert: "Debes iniciar sesión para continuar."
  end
end