FactoryGirl.define do

  factory :jugo, class: Producto do
    nombre "Jugo del Valle"
    diferenciador "Naranja"
    marca "Del Valle"
    presentacion "300 ml"
    precio 2000
    imagen "jugodelvallenaranja.jpg"
  end

  factory :leche, class: Producto do
    nombre "Alqueria"
    diferenciador "Deslactosada"
    marca "Alqueria"
    presentacion "1100 ml"
    precio 2000
    imagen "alqueriadeslactosada.jpg"
  end

  factory :producto do
    nombre "Producto"
    diferenciador "Diferenciador producto"
    marca "Marca producto"
    presentacion "5 kg"
    precio 5000
    imagen "imagen_producto.jpg"
  end

end
