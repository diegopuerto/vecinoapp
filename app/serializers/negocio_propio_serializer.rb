class NegocioPropioSerializer < ActiveModel::Serializer
  attributes :id,
  	:nombre,
    :direccion,
    :latitud,
    :longitud,
    :tipo,
    :cobertura,
    :activo
end
