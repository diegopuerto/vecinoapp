class CreateCategoriasProductos < ActiveRecord::Migration
  def change
    create_table :categorias_productos do |t|
      t.references :producto, index: true, foreign_key: true
      t.references :categoria, index: true, foreign_key: true

      t.index [:categoria_id, :producto_id], unique: true

      t.timestamps null: false

    end
  end
end
