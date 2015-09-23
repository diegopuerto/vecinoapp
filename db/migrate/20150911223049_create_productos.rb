class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |t|
      t.string :nombre, null: false
      t.string :diferenciador
      t.string :marca, null: false
      t.string :presentacion, null: false
      t.decimal :precio
      t.string :imagen, null: false

      t.timestamps null: false
    end
  end
end
