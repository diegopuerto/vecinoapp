# api-vecino

Iniciamos el API con la gema 'rails-api'

    $ rails-api new api-vecino
    $ cd api-vecino/
    $ mv README.rdoc README.md

# Git

    commit 115627b66569d5db824298d74a9458ef7ad7facc

Iniciamos un repositorio Git en el API

    $ git init
    $ git config user.name "Vecino Programador"
    $ git config user.email "programador@vecino.com.co"
    $ git add -A
    $ git commit -m "Comienzo"

Luego creamos un repositorio remoto en Bitbucket y lo asociamos al repositorio local

    $ git remote add origin https://vprogramador@bitbucket.org/vecino/api-vecino.git
    $ git push -u origin --all
    $ git push -u origin --tags

# Configuración API

    $ git checkout -b 00-configuracion-api

## Inicia Gemfile

    commit 79e98cd49a920325ac5b52b4b399cab1b22f3f4e

Editamos el `Gemfile` y corremos el comando `bundle update` para que el API quede actualizado y con las gemas básicas para su funcionamiento.

A medida que se vayan agregando funcionalidades se irán instalando las gemas requeridas.

## Configura [CORS](http://www.w3.org/TR/cors/)

    commit 17c7ea8589fef3a6bd39f65c944a227f10fe4487

Instalamos la gema `rack-cors` agregándola al `Gemfile` y corriendo `bundle install`. Luego la configuramos en `config/application.rb`.

## Configura Serialización

    commit 6f86178a0a4513f49939837cead53a3c299aa14d

Instalamos la gema `active_model_serializers` con la cual vamos a serializar los recursos para que sean consumidos en formato JSON por los clientes Angular.

Se edita el `Gemfile` y se corre `bundle update`

## Instala Generador de Diagramas

    commit 6dd7f714c0317ac92533ae4f90ee247201a0c8fc

Instalamos la gema `rails-erd` en el entorno de desarrollo para generar de forma automática diagramas entidad-relación a partir de los modelos utilizados por el API. Los diagramas se generan con `rake erd`. [Más info](https://github.com/voormedia/rails-erd).

## Implementa ruta y controlador de prueba

    commit 1a893b48fdd7a1d1ed6eec9c10b7b9c2427136a4

Para probar el API configuramos la ruta raíz para que apunte a un controlador de prueba.

Escribimos el controlador de prueba que debe entregar un objeto en formato JSON.

## Configura Producción

    commit 1bbf43d704fda6d69ee1aab8aa29a4c361f54e29

Para subir el API a un entorno de producción primero debemos habilitar la conexión segura con SSL agregando la línea `config.force_ssl = true` en `config/environments/production.rb`.

Luego instalamos las gemas que vamos a utilizar en producción: el servidor `puma`, la gema para PostgreSQL `pg` y la gema `rails_12factor`.

Agregamos estas gemas al `Gemfile` y corremos `bundle install --without production` para actualizar el `Gemfile.lock`.

Creamos el archivo de configuración del servidor Puma `config/puma.rb`

Para correr el servidor Puma en producción tenemos que agregar un archivo `Procfile` con las instrucciones.

### Heroku

Verificamos que `heroku` esté instalado

    $ heroku version

Creamos una cuenta en `heroku.com` e iniciamos sesión

    $ heroku login

Generamos una llave pública para autenticarnos en Heroku con `ssh-keygen` y la guardamos en `~/.ssh` y luego la agregamos

    $ heroku keys:add

Ahora creamos la aplicación y le ponemos un nombre

    $ heroku create api-vecino

Y finalmente hacemos el commit y subimos la aplicación a producción utilizando `git`. A Heroku solo se sube la rama `master`, así que nos pasamos a la rama `master`, hacemos `merge` con la rama `00-configuracion-api` y subimos a heroku.

## BUG - Cambia versión de gema

La gema `active_model_serializers` no funciona bien si se utiliza la versión más reciente (`0.9.3`), por lo que se cambia la versión a la `0.8.3`. Editamos el `Gemfile` y corremos `bundle install`.

## Instala y configura RSpec

    commit 3b4ea683b4e2a40c9668230996e6945463747112

[Rspec](https://en.wikipedia.org/wiki/RSpec) es un framework de [desarrollo dirigido por comportamiento](https://en.wikipedia.org/wiki/Behavior-driven_development) escrito para Ruby.

Agregamos la gema `rspec-rails` al `Gemfile` y la instalamos con `bundle install`

Luego generamos los archivos de configuración

    $ rails generate rspec:install

Este comando nos genera los archivos

  * `.rspec`
  * `spec/spec_helper.rb`
  * `spec/rails_helper.rb`

Agregamos la línea `require 'rails_helper'` en `spec/spec_helper.rb`. Ahora podemos escribir nuestros tests y correrlos con `bundle exec rspec` 

## Instala FactoryGirl

    commit 7f4624caaa7b7037901f037759737cd5b327beae

FactoryGirl es un reemplazo de los fixtures de Rails.

Agregamos la gema al `Gemfile` y la instalamos.

## Configura Mailer

    commit 39ce2efab7a49223789a5d3e38f2b843a7bee104

Agregamos la configuración del servidor de correo para el mailer en `config/environments/development.rb` y `config/environments/production.rb` teniendo en cuenta los diferentes valores para el parámetro `host`.

**Se debe modificar la forma de pasar el parámetro password al archivo de configuración utilizando variables de entorno para no dejar la clave escrita en un archivo que se subirá al entorno de producción.**

# Usuarios

Creamos una nueva rama para esta funcionalidad.

    $ git checkout -b 01-usuarios

## Instala devise_token_auth

    commit ad1e68f56b1d013539859a5b93fc5b28a42aed4c

Primero agregamos las gemas `devise`, `devise_token_auth` y `omniauth` y las instalamos con `bundle update`

## Implementa el recurso Usuario con devise_token_auth

    commit 839789567dd503c49100767109c3ab1eb2acd5ac

Generamos el código para el recurso Usuario con `devise_token_auth`

    $ rails g devise_token_auth:install Usuario

Esto nos crea los siguientes archivos:

  * `config/initializers/devise_token_auth.rb`
  * `db/migrate/20150812125605_devise_token_auth_create_usuarios.rb`
  * `app/models/usuario.rb`

Estos archivos son el inicializador que configura la gema `devise_token_auth`, la migración que crea la tabla Usuarios en la base de datos y la definición del modelo Usuario.

El generador también incluye las rutas proporcionadas por `devise_token_auth` en `config/routes.rb`.

También debería incluir los métodos de `devise_token_auth` en el controlador de la aplicación, pero como no lo hace (probablemente por usar `rails-api`), entonces lo hacemos  nosotros agregando `include DeviseTokenAuth::Concerns::SetUserByToken` al controlador `app/controllers/application_controller.rb`. De esta forma podremos a los métodos de autenticación desde los controladores de los diferentes recursos.

### Migración

En la migración generada para crear la tabla Usuarios se definen los campos de la tabla, y es allí donde vamos a incluir los campos adicionales que se requieren para el usuario y quitar los que no vamos a utilizar (sección confirmable)

    ## Confirmable
    # t.string   :confirmation_token
    # t.datetime :confirmed_at
    # t.datetime :confirmation_sent_at
    # t.string   :unconfirmed_email # Only if using reconfirmable

    ## User Info
    t.string :name
    t.string :nickname, :default => "vecino"
    t.string :image
    t.string :email
    t.string :telefono
    t.boolean :es_admin
    t.boolean :es_propietario

Luego de hacer las modificaciones aplicamos la migración para crear la tabla en la base de datos

    $ rake db:migrate

Podemos verificar que se aplicó la migración con

    $ rake db:migrate:status

Y podremos ver la tabla creada en la base de datos con

    $ sqlitebrowser db/development.sqlite3 &

### Modelo

Al modelo Usuario generado por `devise_token_auth` le vamos desactivar el módulo de `devise` `confirmable`, esto porque no queremos que al usuario le toque confirmar su dirección de correo en el momento del registro.

### Diagrama entidad relación

Como ya tenemos un modelo definido con su respectiva tabla en la base de datos, podemos generar el diagrama entidad relación de la aplicación

    $ rake erd

Con esto se genera el archivo `erd.pdf` que podemos visualizar con `zathura erd.pdf`.

### Serialización

Generamos un serializador para el recurso usuario

    $ rails g serializer usuario

Y especificamos los atributos que queremos que nos entregue el API

    class UsuarioSerializer < ActiveModel::Serializer
      attributes :id,
             :name,
             :email,
             :image,
             :telefono,
             :es_admin,
             :es_propietario
    end

### Mailer

Para poder enviar correos con devise_token_auth la opción `config.mailer_sender` debe coincidir con el nombre de usuario en la configuración del servidor de correo electrónico.

Creamos el inicializador de `devise` con 

    $ rails g devise:install

Y editamos la opción en el archivo `config/initializers/devise.rb`.


### Postman

Para verificar el funcionamiento del registro e inicio de sesión de usuarios utilizamos la aplicación [Postman](), con ella enviamos diferentes peticiones al API para crear usuarios de pruebas. Por medio de la consola validamos que los usuarios nuevos queden almacenados en la base de datos.

**Esto debe reemplazarse por tests**

### Heroku

Luego de hacer el commit nos pasamos a la rama master y hacemos merge con 01-usuarios, subimos a heroku, y como creamos un modelo nuevo, corremos las migraciones en producción

    $ heroku run rake db:migrate

## Pendiente

Escribir los tests para las acciones que provee `devise_token_auth`, es decir, registro de usuarios, sesiones, y recuperación de contraseña.

## Implementa lista de Usuarios - TDD

    commit 579de177d66d9f7d6c1531a1378384db22b3958b

### Test Driven Development

Desarrollo Dirigido por Pruebas es una metodología que establece que para cada unidad de software, el desarrollador debe:

  1. Definir primero un conjunto de pruebas de la unidad
  2. Implementar la unidad
  3. Verificar que la implementación de la unidad hace que las pruebas se pasen

### API RESTful

Las rutas para la gestión del recurso usuarios son:

    GET    /usuarios
    POST   /usuarios
    GET    /usuarios/:id
    PUT    /usuarios/:id
    DELETE /usuarios/:id

que corresponden a las acciones `index`, `create`, `show`, `update` y `destroy`.

Las pruebas de estas rutas del API se basan en dos cosas, el código de estado de la respuesta HTTP y el cuerpo de la respuesta. Los códigos de estado son los siguientes:

  * **200**: OK - Todo bien.
  * **401**: Unauthorized - Credenciales de autenticación no válidas
  * **403**: Forbidden - El recurso solicitado no se puede acceder
  * **404**: Not Found - El recurso no existe en el servidor

### Failing Test

Creamos el primer test, en el cual al recibir la petición `GET /usuarios` el API devuelve una lista de los usuarios en formato JSON.

    $ mkdir spec/requests/
    $ touch spec/requests/usuarios_spec.rb

Una vez escrito el test lo corremos con `bundle exec rspec` y obtenemos como resultado un fallo (`Factory not registered`).

### Factory

El primer fallo que se encuentra es que no se ha registrado ninguna factory para el modelo Usuario, así que la creamos

    $ mkdir spec/factories
    $ touch spec/factories/usuario_factory.rb

Para poder crear las factories es necesario que en la base de datos existan las tablas, por lo que debebemos asegurarnos de correr las migraciones en el ambiente de pruebas

    $ rake db:migrate RAILS_ENV=test

Luego podemos acceder por consola y verificar el funcionamiento de la factory

    $ rails c test
    > FactoryGirl.create :usuario_uno
    > Usuario.first.destroy

El usuario en el ambiente de pruebas lo creamos y luego lo destruimos porque si no cuando corremos el test nos va a decir que la dirección de correo ya está en uso.

### rutas

Al crear la Factory solucionamos el primer fallo y obtenemos el segundo : `No route matches [GET] "/usuarios"`.

Para solucionar este agregamos la ruta en `config/routes.rb`.

    resources :usuarios, only: [:index], :defaults => { :format => :json }

### Controlador

Con las rutas solucionamos el segundo fallo y obtenemos el tercero: `uninitialized constant UsuariosController`.

Este lo solucionamos creando el controlador de usuarios.

    $ touch app/controllers/usuarios_controller.rb

    class UsuariosController < ApplicationController
    end

### Acción

Una vez creado el controlador solucionamos el tercer fallo y obtenemos el cuarto: `The action 'index' could not be found for UsuariosController`.

Para solucionar este creamos la acción `index` en el controlador de los usaurios.

Con este último paso obtenemos el passing test y la nueva funcionalidad.

## Implementa ver usuario

    commit a41ab729f3b4588126a18093c93a2c73c3e8b9d2

Primero creamos el Test correspondiente a esta acción en `spec/requests/usuarios_spec.rb`.

Luego vamos solucionando los fallos creando la ruta y la acción correspondiente.

## Implementa eliminar usuario

    commit 35dec8645226e274534360324b4d3f9488d861e8

Primero creamos el Test correspondiente a esta acción en `spec/requests/usuarios_spec.rb`.

Luego vamos solucionando los fallos creando la ruta y la acción correspondiente.

## Implementa crear usuario

    commit 0733c45f2927eea5dc6f054b8a71f6bd15a5a7a9

Primero creamos el Test correspondiente a esta acción en `spec/requests/usuarios_spec.rb`.

Luego vamos solucionando los fallos creando la ruta y la acción correspondiente.

## Implementa actualizar usuario

    commit d5a66a1019763005ab7b34546ffdf1950c12e9bb

Primero creamos el Test correspondiente a esta acción en `spec/requests/usuarios_spec.rb`.

Luego vamos solucionando los fallos creando la ruta y la acción correspondiente.

*So you should not write tests that look for stored passwords being equal to known values. Instead, your tests around password handling should be more black box, and assert that you can log in with the known password, and not login with any others (including code-breaking cases such as nils, empty strings, super-long passwords and a string which matches the hashed password). [so](http://stackoverflow.com/questions/16603559/rspec-the-passwords-in-my-test-are-not-matching-up)*.

# Direcciones

Vamos a crear un nuevo recurso llamado **Direcciones**, que serán utilizadas por los usuarios a la hora de realizar sus pedidos para indicar fácilmente su ubicación.

Un usuario podrá tener ninguna, una o muchas direcciones asociadas, y las direcciones tendrán la siguiente información:

  * **nombre**: "casa"
  * **lat**: 4.54
  * **long**: -23.98
  * **texto**: "carrera 4 # 21 - 56"
  * **detalles**: "Por la calle peatonal"

## Modelo

    commit

Primero generamos un modelo con los atributos requeridos

    $ rails g model Direccion nombre:string lat:float long:float texto:string detalles:text usuario:references

La parte `usuario:references` asocia las direcciones con los usuarios agregándole a la tabla una columna `usuario_id` así como un índice y una llave foránea.

Al generar el modelo obtenemos los siguientes archivos 

    db/migrate/20150826153620_create_direccions.rb
    app/models/direccion.rb
    spec/models/direccion_spec.rb
    spec/factories/direccions.rb

Se produce un error al generar la forma plurar porque no lo hace en español

    > "usuario".pluralize
     => "usuarios" 
    > "direccion".pluralize
     => "direccions"

Para corregir esto tenemos que agregar las [reglas de pluralización para el español](https://github.com/davidcelis/inflections/blob/master/lib/inflections/es.rb) en `config/environment.rb`

  ActiveSupport::Inflector.inflections do |inflect|
    inflect.clear

    inflect.plural(/$/, 's')
    inflect.plural(/([^aeéiou])$/i, '\1es')
    inflect.plural(/([aeiou]s)$/i, '\1')
    inflect.plural(/z$/i, 'ces')
    inflect.plural(/á([sn])$/i, 'a\1es')
    inflect.plural(/é([sn])$/i, 'e\1es')
    inflect.plural(/í([sn])$/i, 'i\1es')
    inflect.plural(/ó([sn])$/i, 'o\1es')
    inflect.plural(/ú([sn])$/i, 'u\1es')

    inflect.singular(/s$/, '')
    inflect.singular(/es$/, '')
    inflect.singular(/([sfj]e)s$/, '\1')
    inflect.singular(/ces$/, 'z')

    inflect.irregular('el', 'los')
  end

Luego volvemos a generar el modelo y obtenemos los archivos con los nombres correctos.

### Asociaciones

Ahora editamos `app/models/direccion.rb` para agregarle las relaciones que tendrá este recurso con los otros existentes en el sistema.

La primera asociación que vamos a declarar en `app/models/direccion.rb` es `belongs_to :usuario`, ya que cada dirección pertenece a un usuario.

Este tipo de asociación requiere una llave foránea en la tabla direcciones que apunte a un elemento de la tabla usuarios, por lo que tenemos que modificar la migración para reflejar la asociación en las tablas agregando el campo `t.belongs_to :usuario, index: true`.

Para complementar la relación entre los recursos, en `app/models/usuario.rb` declaramos la asociación `has_many :direcciones, dependent: :destroy`, la última parte la agregamos para indicarle a rails que si se elimina un usuario, se deben eliminar las direcciones asociadas a él también.

### Migración

A continuación revisamos la migración y agregamos las restricciones o los valores por defecto de las columnas según se requiera

    class CreateDirecciones < ActiveRecord::Migration
      def change
        create_table :direcciones do |t|
          t.string :nombre, null: false
          t.float :lat, null: false
          t.float :long, null: false
          t.string :texto, null: false
          t.text :detalles
          t.belongs_to :usuario, index: true

          t.timestamps null: false
        end
      end
    end

Luego aplicamos la migración.

    $ rake db:migrate

Luego de aplicar la migración podemos revisar en la consola los métodos que obtenemos por declarar las relaciones entre los recursos

    > d = Direccion.new
    > d.usuario = Usuario.first
    > d.nombre = "casa"
    > d.lat = 10
    > d.long = -3
    > d.texto = "carrera 3 4 3"
    > d.save
    > u = Usuario.first
    > u.direcciones
    > u.direcciones.first
    > d == u.direcciones.first

### Diagrama Entidad Relación

Para tener una perspectiva gráfica de las relaciones entre los recursos del sistema, generamos un diagrama entidad relación.

    $ rake erd

### Test Unitarios

**Pediente realizar test unitarios con rspec**

### Validaciones

Agregamos al modelo las validaciones requeridas por la lógica del negocio y la integridad de la información.

    # Validaciones
    validates_presence_of :nombre, :lat, :long, :texto, :usuario_id
    validates :lat, numericality: { greater_than_or_equal_to: -90,
                                    less_than_or_equal_to: 90 }
    validates :long, numericality: { greater_than_or_equal_to: -180,
                                     less_than_or_equal_to: 180 }

### Serialización

Generamos un serializador para el recurso 

    $ rails g serializer direccion

Y especificamos los atributos que queremos que nos entregue el API. 

    attributes :id,
         :nombre,
         :lat,
         :long,
         :texto,
         :detalles

También especificamos la relaciones entre los recursos para que sean tomadas en cuenta a la hora de entregar el objeto JSON, en `app/serializers/direccion_serializer.rb` agregamos `belongs_to :usuario`, no ponemos nada en `app/serializers/usuarios_serializer.rb` porque no vamos a solicitar direcciones de forma independiente al API, solo vamos a interactuar con ellas a través de los usuarios, por lo que no necesitamos que al pedir una dirección, esta nos traiga el usuario al que pertenece.