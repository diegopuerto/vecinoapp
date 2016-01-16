class Usuario < ActiveRecord::Base

	# Callbacks
  before_destroy :que_no_sea_propietario_único
  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, 
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Asociaciones
  has_many :direcciones, dependent: :destroy
  has_many :propietarios_negocios
  has_many :negocios_propios, through: :propietarios_negocios,
  	source: :negocio
  has_many :pedidos, dependent: :destroy

  private

	  def que_no_sea_propietario_único
	    if self.negocios_propios.empty?
	    	return true
	    else
		   	self.negocios_propios.each do |n|
	   	  	if n.propietarios.count > 1
	   	  		return true
	   	  	else
	   	  		errors.add(:base, 'propietario único, primero borre los negocios propios')
		   			return false
		   		end
	 		  end
	 		end
		end  

end
