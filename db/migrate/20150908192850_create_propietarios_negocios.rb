class CreatePropietariosNegocios < ActiveRecord::Migration
  def change
    create_table :propietarios_negocios do |t|
      t.references :usuario, index: true, foreign_key: true
      t.references :negocio, index: true, foreign_key: true

      t.timestamps null: false

      t.index [:usuario_id, :negocio_id], unique: true
    end
  end
end
