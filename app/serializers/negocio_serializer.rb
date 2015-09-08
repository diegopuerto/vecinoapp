class NegocioSerializer < ActiveModel::Serializer
  attributes :id,
  	:nombre,
    :direccion,
    :latitud,
    :longitud,
    :reputacion,
    :tiempo_entrega,
    :pedido_minimo,
    :recargo,
    :tipo,
    :cobertura,
    :telefono,
    :imagen,
    :activo,
    :hora_apertura,
    :hora_cierre

  def pedido_minimo
  	object.pedido_minimo.to_i
  end

  def recargo
  	object.recargo.to_i
  end

  def hora_apertura
  	object.hora_apertura.strftime("%I:%M %p")
  end

  def hora_cierre
  	object.hora_cierre.strftime("%I:%M %p")
  end

end
