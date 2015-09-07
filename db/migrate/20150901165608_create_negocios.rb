class CreateNegocios < ActiveRecord::Migration
  def change
    create_table :negocios do |t|
      t.string :nombre, null: false
      t.string :direccion, null: false
      t.float :latitud, null: false
      t.float :longitud, null: false
      t.integer :reputacion, default: 0
      t.integer :tiempo_entrega, default: 15
      t.decimal :pedido_minimo, default: 0
      t.decimal :recargo, default: 0
      t.integer :tipo, default: 0
      t.integer :cobertura, null: false
      t.string :telefono, null: false
      t.string :imagen
      t.boolean :activo, default: false
      t.time :hora_apertura, null: false
      t.time :hora_cierre, null: false

      t.timestamps null: false
    end
  end
end
