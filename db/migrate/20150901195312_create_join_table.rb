class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :propietarios, :negocios_propios do |t|
      t.integer :propietario_id
      t.integer :negocio_propio_id

      t.index :negocio_propio_id
      t.index :propietario_id
      t.index [:propietario_id, :negocio_propio_id], unique: true, name: 'by_negocio_propietario'
    end
  end
end
