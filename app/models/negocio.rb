class Negocio < ActiveRecord::Base
  
  # Callbacks
  after_save :actualizar_propietarios
  before_destroy :actualizar_propietarios_before_destroy

  # Asociaciones
  has_and_belongs_to_many :propietarios,
   class_name: 'Usuario',
   join_table: 'negocios_propios_propietarios',
   foreign_key: 'negocio_propio_id',
   association_foreign_key: 'propietario_id',
   after_add: :actualizar_propietario,
   after_remove: :actualizar_propietario

  # Validaciones
  validates_presence_of :nombre, :direccion, :latitud, :longitud,
   :tiempo_entrega, :cobertura, :telefono, :hora_apertura, :hora_cierre,
   :propietarios
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
	      	errors.add(:hora_apertura, "Debe cerrar después de abrir")
	      	errors.add(:hora_cierre, "Debe cerrar después de abrir")
	   		 end
	  	end
    end

    # Actualiza los propietarios al agregar o quitarlos
    def actualizar_propietario(propietario)
      propietario.es_propietario = !propietario.negocios_propios.empty?
      propietario.save
    end

    # Actualiza propietarios cuando se crea el negocio
    def actualizar_propietarios
      self.propietarios.each do | p |
      	p.es_propietario = !p.negocios_propios.empty?
      	p.save
      end
    end

    def actualizar_propietarios_before_destroy
      self.propietarios.each do | p |
      	p.es_propietario = false if p.negocios_propios.count == 1
       	p.save
      end
    end

end