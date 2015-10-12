class CreateNegociosProductos < ActiveRecord::Migration
  def change
    create_table :negocios_productos do |t|
      t.references :negocio, index: true, foreign_key: true
      t.references :producto, index: true, foreign_key: true
      t.string :precio

      t.index [:negocio_id, :producto_id], unique: true

      t.timestamps null: false
    end
  end
end
