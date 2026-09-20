class Libro < ApplicationRecord
  belongs_to :categoria

  has_many :lecturas, dependent: :destroy

  validates :titulo, presence: true
  validates :autor, presence: true
  validates :unidades, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
