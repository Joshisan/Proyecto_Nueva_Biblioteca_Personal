class Categoria < ApplicationRecord
  has_many :libros, dependent: :restrict_with_error

  validates :nombre, presence: true, uniqueness: true
end
