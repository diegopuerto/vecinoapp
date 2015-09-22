class Categoria < ActiveRecord::Base
	validates_presence_of :nombre
	validates_presence_of :imagen
end
