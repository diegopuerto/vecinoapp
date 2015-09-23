class CreateCategorias < ActiveRecord::Migration
  def change
    create_table :categorias do |t|
      t.string :nombre, null: false
      t.string :imagen

      t.timestamps null: false
    end
  end
end
