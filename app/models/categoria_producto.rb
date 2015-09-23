class CategoriaProducto < ActiveRecord::Base
  #Asociaciones	
  belongs_to :producto
  belongs_to :categoria

  #Validaciones
  validates_presence_of :categoria, :producto
  validates_uniqueness_of :producto, scope: :categoria
end
