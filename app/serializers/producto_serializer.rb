class ProductoSerializer < ActiveModel::Serializer
  attributes :id,
  	:nombre,
  	:diferenciador,
  	:marca,
  	:presentacion,
  	:precio,
  	:imagen

  	def precio
  		object.precio.to_i
  	end
end
