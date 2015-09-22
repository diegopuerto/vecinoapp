require 'rails_helper'

RSpec.describe Categoria, type: :model do
  it "es valido con todos sus datos" do 
		@categoria = FactoryGirl.build(:categoria)
		expect(@categoria).to be_valid
	end

	describe "Atributos requeridos" do
			it "Es invalido sin nombre" do
			 	@categoria = FactoryGirl.build(:categoria, nombre: nil)
	  			@categoria.valid?
	  			expect(@categoria.errors[:nombre]).to include(I18n.t 'errors.messages.blank')
			end

			it "es inválido sin imagen" do
		  		@categoria = FactoryGirl.build(:categoria, imagen: nil)
		  		@categoria.valid?
		  		expect(@categoria.errors[:imagen]).to include(I18n.t 'errors.messages.blank')
			end
	end
end
