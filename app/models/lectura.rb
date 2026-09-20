class Lectura < ApplicationRecord
  belongs_to :usuario
  belongs_to :libro

  validates :estado, inclusion: { in: %w[pendiente en_proceso leido] }
  validates :usuario_id, uniqueness: { scope: :libro_id }

  before_save :registrar_fechas_de_lectura

  private

  def registrar_fechas_de_lectura
    return unless will_save_change_to_estado?

    estado_anterior, estado_nuevo = estado_change_to_be_saved

    if estado_anterior == "pendiente" && estado_nuevo == "en_proceso"
      self.fecha_inicio ||= Date.current
    end

    if estado_anterior == "en_proceso" && estado_nuevo == "leido"
      self.fecha_finalizacion ||= Date.current
    end
  end
end
