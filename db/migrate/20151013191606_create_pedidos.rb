class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.integer :propina
      t.text :comentario
      t.integer :total, null: false
      t.integer :estado, :default => 0
      t.integer :medio_pago, :default => 0
      t.references :negocio, index: true, foreign_key: true
      t.references :usuario, index: true, foreign_key: true
      t.references :direccion, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
