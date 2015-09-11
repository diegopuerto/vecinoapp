class Negocio < ActiveRecord::Base

  # Callbacks
  before_destroy :actualizar_propietarios
  
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
  validate :activar_si_tiene_un_propietario

  # Tipo
  enum tipo: [:tienda, :drogueria, :papeleria]

  # Asociaciones
  has_many :propietarios_negocios
  has_many :propietarios, through: :propietarios_negocios,
    source: :usuario

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

    # Valida que exista al menos un propietario antes de activar el negocio
    def activar_si_tiene_un_propietario
      if self.activo && self.propietarios.empty?
        errors.add(:activo, (I18n.t 'errors.messages.need_a_proprietary'))
      end
    end

    # Actualiza el atributo es_propietario de sus propietarios cuando se elimina
    def actualizar_propietarios
      self.propietarios.each do |p|
        p.es_propietario = false if p.negocios_propios.count == 1
        p.save
      end
    end
end