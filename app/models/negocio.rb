class Negocio < ActiveRecord::Base
  
  # Validaciones
  validates_presence_of :nombre, :direccion, :latitud, :longitud,
   :tiempo_entrega, :cobertura, :telefono, :hora_apertura, :hora_cierre
  validates :nombre, length: { maximum: 50 }
  validates :direccion, length: { maximum: 255 }
  validates :latitud,
   numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitud,
   numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :reputacion,
   numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :tiempo_entrega,
   inclusion: { in: [15, 30, 45, 60, 75, 90, 105, 120] }
  validates :pedido_minimo,
   numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :recargo,
   numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :cobertura,
   numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validate :horario_positivo

  # Tipo
  enum tipo: [:tienda, :drogueria, :papeleria]

  private

    # Valida que la hora de cierre sea posterior a la hora de apertura
    def horario_positivo
      if self.hora_cierre && self.hora_apertura
      	unless self.hora_cierre > self.hora_apertura
	      	errors.add(:hora_apertura, (I18n.t 'errors.messages.open_before_close'))
	      	errors.add(:hora_cierre, (I18n.t 'errors.messages.open_before_close'))
	   		 end
	  	end
    end

end