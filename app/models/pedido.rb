class Pedido < ActiveRecord::Base
  belongs_to :negocio
  belongs_to :usuario
  belongs_to :direccion

  #Validaciones
  validates_presence_of :total, :estado, :medio_pago
  validates :total,
   	 numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :comentario, length: { maximum: 200 }
  validates :propina,
   	 numericality: { greater_than_or_equal_to: 0, only_integer: true }

  enum estado: [ :nuevo, :enviado, :cancelado, :recibido ]
end
