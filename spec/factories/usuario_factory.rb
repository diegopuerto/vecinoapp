FactoryGirl.define do

  factory :usuario_uno, class: Usuario do
  	uid "usuario1@correo.com"
    provider "email"
    password "clavesecreta"
    email "usuario1@correo.com"
    name "Usuario Uno"
    image "usuario1.png"
    telefono "3004560987"
    es_admin false
    es_propietario false
  end

  factory :usuario_dos, class: Usuario do
  	uid "usuario2@correo.com"
    provider "email"
    password "clavesecreta"
    email "usuario2@correo.com"
    name "Usuario Dos"
    image "usuario2.png"
    telefono "3006785432"
    es_admin false
    es_propietario false
  end

end
