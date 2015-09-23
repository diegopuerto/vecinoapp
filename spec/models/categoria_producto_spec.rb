require 'rails_helper'

RSpec.describe CategoriaProducto, type: :model do
  
  describe "Atributos" do

		it "es válido con todos sus datos" do
	  		@categoria_producto = FactoryGirl.build(:categoria_producto)
			@categoria_producto.categoria = FactoryGirl.build(:bebidas)
			@categoria_producto.producto = FactoryGirl.build(:jugo)
			expect(@categoria_producto).to be_valid
	  end

		it "es inválido si falta algún dato" do
	  		@categoria_producto = FactoryGirl.build(:categoria_producto)
			@categoria_producto.valid?
			expect(@categoria_producto.errors[:categoria]).to include(I18n.t 'errors.messages.blank')
			expect(@categoria_producto.errors[:producto]).to include(I18n.t 'errors.messages.blank')
	  end

	  it "es inválido si el par categoria-producto no es único" do
	  	@categoria = FactoryGirl.build(:bebidas)
	  	@producto = FactoryGirl.build(:jugo)
	  	@categoria_producto = FactoryGirl.create(:categoria_producto,
	  		categoria: @categoria,
	  		producto: @producto)
	  	@categoria_producto_no_valido = FactoryGirl.build(:categoria_producto,
	  		categoria: @categoria,
	  		producto: @producto)
	  	expect(@categoria_producto_no_valido).to be_invalid
	  	expect(@categoria_producto_no_valido.errors[:producto]).to include(I18n.t 'errors.messages.taken')
	  end

	  it "es inválido si la categoria o el producto no existen" do
	  	@categoria_producto = FactoryGirl.build(:categoria_producto)
	  	expect(Categoria.exists?(1)).to be false
	  	expect(Producto.exists?(1)).to be false
	  	@categoria_producto.categoria_id = 1
	  	@categoria_producto.producto_id = 1
	  	expect(@categoria_producto).to be_invalid
	  	expect(@categoria_producto.errors[:categoria]).to include(I18n.t 'errors.messages.blank')
	  	expect(@categoria_producto.errors[:producto]).to include(I18n.t 'errors.messages.blank')
	  end
	end


end
