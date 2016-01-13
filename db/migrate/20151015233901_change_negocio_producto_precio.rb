class ChangeNegocioProductoPrecio < ActiveRecord::Migration
def up
    change_table :negocios_productos do |t|
      t.change :precio, :decimal
    end
  end

  def down
    change_table :negocios_productos do |t|
      t.change :precio, :string
    end
  end
end
