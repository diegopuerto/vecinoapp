class Producto < ActiveRecord::Base

	validates_presence_of :nombre
	validates_presence_of :marca
	validates_presence_of :presentacion
	validates_presence_of :imagen
	validates :nombre, length: { maximum: 50 }
	validates :diferenciador, length: { maximum: 50 }
	validates :marca, length: { maximum: 50 }
	validates :presentacion, length: { maximum: 50 }
	validates :precio,
   	 numericality: { greater_than_or_equal_to: 0, only_integer: true }
   	validates :imagen, length: { maximum: 50 }


end
