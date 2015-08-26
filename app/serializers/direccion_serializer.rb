class DireccionSerializer < ActiveModel::Serializer
  attributes :id,
  			 :nombre,
  			 :lat,
  			 :long,
  			 :texto,
  			 :detalles
end
