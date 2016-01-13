class PedidoProducto < ActiveRecord::Base
  belongs_to :pedido
  belongs_to :producto

  #Validaciones
  validates_presence_of :pedido, :producto, :cantidad, :precio
  validates_uniqueness_of :producto, scope: :pedido

  validates :cantidad, numericality: { greater_than_or_equal_to: 0 }
  validates :precio, numericality: { greater_than_or_equal_to: 0 }
end
 