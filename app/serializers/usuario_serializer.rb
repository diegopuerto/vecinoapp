class UsuarioSerializer < ActiveModel::Serializer
  attributes :id,
  			 :name,
  			 :email,
  			 :image,
  			 :telefono,
  			 :es_admin,
  			 :es_propietario
end
