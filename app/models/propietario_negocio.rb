class PropietarioNegocio < ActiveRecord::Base

	# Callbacks
	before_destroy { |record| actualizar_propietario(:destroy, record) }
	before_destroy { |record| actualizar_negocio(record) }
	after_save { actualizar_propietario(:save, nil) }
  
  # Asociaciones
  belongs_to :usuario
  belongs_to :negocio

  # Validaciones
  validates_presence_of :usuario, :negocio
  validates_uniqueness_of :usuario, scope: :negocio

  private

  	def actualizar_propietario(callback, record)
  		if callback == :destroy && record
  			record.usuario.es_propietario = false if record.usuario.negocios_propios.count == 1
  			record.usuario.save
  		else
  			self.usuario.es_propietario = !self.usuario.negocios_propios.empty?
  			self.usuario.save
  		end
  	end

  	def actualizar_negocio(record)
  		record.negocio.activo = false if record.negocio.propietarios.count == 1
  		record.negocio.save
  	end

end
