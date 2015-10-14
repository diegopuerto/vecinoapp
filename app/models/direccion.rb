class Direccion < ActiveRecord::Base
  
  # Asociaciones
  belongs_to :usuario
  has_many :pedidos, dependent: :destroy

  # Validaciones
  validates_presence_of :nombre, :lat, :long, :texto, :usuario_id
  validates :lat, numericality: { greater_than_or_equal_to: -90,
                                  less_than_or_equal_to: 90 }
  validates :long, numericality: { greater_than_or_equal_to: -180,
                                   less_than_or_equal_to: 180 }
end
