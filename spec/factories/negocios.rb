FactoryGirl.define do

  factory :tienda, class: Negocio do
    nombre "Tienda Rspec"
	direccion "Carrera 14 # 5 - 5"
	latitud 1.5
	longitud -1.5
	reputacion 1000
	tiempo_entrega 15
	pedido_minimo 30000
	recargo 3000
	tipo "tienda"
	cobertura 1000
	telefono "4432211"
	imagen ""
	activo false
	hora_apertura "2015-09-01 05:56:08"
	hora_cierre "2015-09-01 11:56:08"
  end

end
