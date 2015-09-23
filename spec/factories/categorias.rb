FactoryGirl.define do
  factory :bebidas, class: Categoria do
    nombre "Bebidas"
	imagen "imagen_bebidas.jpg"
  end

  factory :lacteos, class: Categoria do
    nombre "Lacteos"
	imagen "imagen_lacteos.jpg"
  end

  factory :categoria do
    nombre "Categoria"
	   imagen "imagen_categoria.jpg"
  end

end
