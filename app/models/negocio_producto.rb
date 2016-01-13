class NegocioProducto < ActiveRecord::Base
  belongs_to :negocio
  belongs_to :producto

  #Validaciones
  validates_presence_of :negocio, :producto
  validates_uniqueness_of :producto, scope: :negocio

end
