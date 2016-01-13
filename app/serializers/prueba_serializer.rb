class PruebaSerializer < ActiveModel::Serializer
  attributes :id
	def precio
		object.precio.to i
	end
end
