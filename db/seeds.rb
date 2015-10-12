# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Producto.create(nombre: 'Crispetas', presentacion: '91g', marca: 'Act II', diferenciador: 'Mantequilla', precio: 2800, imagen: 'PasabocasPalomitas de Maiz91 gAct IIMantequ.jpg')

#Categoria.create(nombre: 'Despensa', imagen: 'prueba.jpg')


require 'csv'

CSV.foreach("db/categorias_061015.csv", { encoding: "ISO-8859-1", col_sep: ";", headers: true, header_converters: :symbol, converters: :all}) do |fila|
 Categoria.create(fila.to_hash)
end


CSV.foreach("db/productos_061015.csv", { encoding: "ISO-8859-1", col_sep: ";", headers: true, header_converters: :symbol, converters: :all}) do |fila|
 Producto.create(fila.to_hash)
end

CSV.foreach("db/productos_con_categoria_ids.csv", { encoding: "ISO-8859-1", col_sep: ";", headers: true, header_converters: :symbol, converters: :all}) do |fila|
 CategoriaProducto.create(fila.to_hash)
end
