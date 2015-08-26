class CreateDirecciones < ActiveRecord::Migration
  def change
    create_table :direcciones do |t|
      t.string :nombre, null: false
      t.float :lat, null: false
      t.float :long, null: false
      t.string :texto, null: false
      t.text :detalles
      t.belongs_to :usuario, index: true

      t.timestamps null: false
    end
  end
end
