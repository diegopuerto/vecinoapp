class Pedido < ActiveRecord::Base
  belongs_to :negocio
  belongs_to :usuario
  belongs_to :direccion
  has_many :pedidos_productos
  has_many :productos, through: :pedidos_productos do 
    def con_precio
      proxy_association.target.each do | p |
        negocio = proxy_association.owner.negocio_id
        np = NegocioProducto.find_by negocio_id: negocio, producto_id: p.id
        preciopedido = np.precio
        p.precio = preciopedido
      end
    end
  end

  # nested attributes
  accepts_nested_attributes_for :pedidos_productos, allow_destroy: true
    
  #Validaciones
  validates_presence_of :total, :estado, :medio_pago
  validates :total,
   	 numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :comentario, length: { maximum: 200 }
  validates :propina,
   	 numericality: { greater_than_or_equal_to: 0, only_integer: true }

  enum estado: [ :nuevo, :enviado, :cancelado, :recibido ]
  enum medio_pago: [:efectivo, :tarjeta_debito, :tarjeta_credito]

end
