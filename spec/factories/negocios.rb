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
		imagen "imagen.png"
		activo false
		hora_apertura "05:56 AM"
		hora_cierre "11:56 PM"
  end

  factory :papeleria, class: Negocio do
    nombre "Papeleria Rspec"
		direccion "Carrera 14 # 1 - 5"
		latitud 1.8
		longitud -7.5
		reputacion 1700
		tiempo_entrega 30
		pedido_minimo 2000
		recargo 10000
		tipo "papeleria"
		cobertura 2000
		telefono "4432568"
		imagen ""
		activo false
		hora_apertura "05:56 AM"
		hora_cierre "11:56 PM"
  end

  factory :negocio_nuevo, class: Negocio do
    nombre "Nuevo Rspec"
		direccion "Carrera 44 # 2 - 5"
		latitud 1.1
		longitud -5.5
		reputacion 4700
		tiempo_entrega 30
		pedido_minimo 4000
		recargo 50000
		tipo "papeleria"
		cobertura 1000
		telefono "4532568"
		imagen ""
		activo false
		hora_apertura "05:56 AM"
		hora_cierre "11:56 PM"
  end
end
