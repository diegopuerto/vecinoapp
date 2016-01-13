FactoryGirl.define do
  factory :pedido do
    propina 1
	comentario "MyText"
	total 1
	estado 1
	medio_pago 1
	negocio nil
	usuario nil
	direccion nil
  end

  factory :pedido_uno, class: Pedido do
    propina 500
    comentario "propina_uno"
    total 2000
    estado 2
    medio_pago 1
    negocio nil
    usuario nil
    direccion nil
  end

  factory :pedido_dos, class: Pedido do
    propina 1000
    comentario "propina_dos"
    total 4000
    estado 3
    medio_pago 1
    negocio nil
    usuario nil
    direccion nil
  end

end
