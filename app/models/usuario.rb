class Usuario < ApplicationRecord
  has_secure_password

  has_many :lecturas, dependent: :destroy

  before_validation :normalizar_email

  validates :nombre, presence: true
  validates :apellido, presence: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :password,
            length: { minimum: 8 },
            allow_nil: true

  validates :rol,
            inclusion: { in: %w[usuario administrador demo] }

  def administrador?
    rol == "administrador"
  end

  def usuario?
    rol == "usuario"
  end

  def demo?
    rol == "demo"
  end

  private

  def normalizar_email
    self.email = email.to_s.strip.downcase
  end
end