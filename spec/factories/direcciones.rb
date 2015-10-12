FactoryGirl.define do

  factory :direccion_casa, class: Direccion do
    nombre "casa"
    lat 1.5
    long 1.1
    texto "Calle 2 2 1"
    detalles "por la bajada"
  end

  factory :direccion_oficina, class: Direccion do
    nombre "oficina"
    lat -21.5
    long 4.1
    texto "Carrera 3 2 1 of 301"
    detalles ""
  end

  factory :direccion_nueva, class: Direccion do
    nombre "casa nueva"
    lat 22
    long -43
    texto "carrera 4 2 1"
    detalles "la casa grande"
  end

end
