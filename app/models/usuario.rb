class Usuario < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, 
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Asociaciones
  has_many :direcciones, dependent: :destroy

end
