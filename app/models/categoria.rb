class Categoria < ActiveRecord::Base
	validates_presence_of :nombre
	validates :nombre, length: { maximum: 100 }
	validates :imagen, length: { maximum: 150 }

	has_many :categorias_productos
	has_many :productos, through: :categorias_productos

end
