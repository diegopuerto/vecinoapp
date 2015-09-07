class Usuario < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, 
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Callbacks
  before_destroy :que_no_sea_propietario_único

  # Asociaciones
  has_many :direcciones, dependent: :destroy
  has_and_belongs_to_many :negocios_propios,
   class_name: 'Negocio',
   join_table: 'negocios_propios_propietarios',
   foreign_key: 'propietario_id',
   association_foreign_key: 'negocio_propio_id'

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
