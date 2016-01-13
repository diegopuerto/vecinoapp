class ChangePedidoProductoPrecio < ActiveRecord::Migration
 def up
    change_table :pedidos_productos do |t|
      t.change :precio, :decimal
    end
  end
 
  def down
    change_table :pedidos_productos do |t|
      t.change :precio, :integer
    end
  end
end
