class PedidoSerializer < ActiveModel::Serializer
  attributes :id,
  :propina,
  :comentario,
  :total,
  :estado,
  :medio_pago
end
