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

    commit 94ae169f7f2c03deb5d3f0b3c22fd3520a3b786e

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

## API RESTful - TDD

Las Direcciones son objetos que pertenecen a los usuarios y vamos a interactuar con ellas a través de los usuarios, es decir, no vamos a gestionar las direcciones de forma independiente, si no que siempre lo vamos a hacer a través de usuarios, con urls anidadas a este recurso.

Si queremos crear, editar, ver o eliminar una dirección primero tenemos que determinar el usuario relacionado.

### Failing Tests

Escribimos los tests para cada una de las peticiones del API en `spec/requests/direcciones_spec.rb`. Inicialmente estos test fallan porque no hemos implementado ninguna acción.

### Factories

Para realizar las pruebas creamos dos factories de direcciones en `spec/factories/direcciones.rb`.

Como las direcciones van a estar asociadas siempre a un usuario, la forma de usar estas factories en los test es diferente, ya que primero creamos un usuario y luego por medio de ese usuario creamos la dirección

    u = FactoryGirl.create(:usuario_uno) do |usuario|
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_oficina))
      end

### Rutas

Definimos las rutas del recurso en `config/routes.rb` anidándolas en las del recurso Usuarios

    resources :usuarios,
     except: [:edit, :new],
     defaults: { format: :json } do

      resources :direcciones,
       except: [:edit, :new],
       defaults: { format: :json }

    end

### Controlador

Generamos el controlador para las direcciones

    $ rails g controller direcciones

y en él escribimos las acciones del recurso.

## BUG FIX - No se puede eliminar dirección

    commit 43d16deb8627cec9631a29f8246641ee451c5d80

Se agrega la ruta para DELETE en el recurso dirección en `config/routes.rb`

    resources :direcciones, only: [:destroy], defaults: { format: :json }

También se agrega test en `spec/requests/direcciones_spec.rb`

    # destroy
    describe "DELETE /direcciones/:id" do
      it "Elimina una dirección de un usuario" do
        u = FactoryGirl.create(:usuario_uno) do |usuario|
          usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
        end

        d =  u.direcciones.first

        delete "/direcciones/#{d.id}", {}, { "Accept" => "application/json" }

        expect(response.status).to be 204 # No Content
        expect(Direccion.count).to eq 0
      end
    end

## BUG FIX - No se puede editar dirección

    commit 5b3d7cf82971f9b798b7c49b9e248337e0cf3907

Se agrega la ruta para PATCH en el recurso dirección en `config/routes.rb`

    resources :direcciones, only: [:destroy, :update], defaults: { format: :json }

También se agrega test en `spec/requests/direcciones_spec.rb`

# Negocios

Vamos a crear un nuevo recurso llamado **Negocios**, cada negocio estará asociado a uno o más usuarios (propietarios) y cada usuario podrá estar asociado a cero, uno o más negocios (negocios propios).

La asociación del negocio con el usuario propietario se hace al momento de crear el negocio y se recibe como parámetro el id del usuario, luego de realizar la asociación se debe actualizar el atributo `es_propietario` del usuario asociado al negocio.

Después de crear el negocio se le pueden agregar o quitar propietarios. Si el negocio tiene un propietario único, este usuario no se puede eliminar. Luego de eliminar una asociación, si es necesario, se debe actualizar el parámetro `es_propietario` del usuario cuya asociación se eliminó.

Para cada negocio se va a guardar la siguiente información 

  * **nombre**: Tienda Michel
  * **direccion**: carrera 4 # 21 - 56
  * **latitud**: 4.54
  * **longitud**: -23.98
  * **reputacion**: 5000 puntos
  * **tiempo_entrega**: 15 minutos
  * **pedido_mínimo**: $5000
  * **tipo**: tienda o papelería o droguería, etc
  * **cobertura**: 3000 metros a la redonda
  * **telefono**: 5542312
  * **imagen**: logo.png
  * **activo**: true
  * **hora_cierre**: 11:00 pm
  * **hora_apertura**: 06:00 am

*Se debe determinar si el negocio está **abierto** o **cerrado** a partir de los atributos `hora_cierre` y `hora_apertura`. Una opción es implementar una tarea programada (gema whenever) que revise estos atributos cada 30 min y actualice el estado del negocio, pero no parece ser la más óptima. Por ahora se va a hacer la validación en el frontend agregándole un método al modelo Restmod*

## Modelo

    commit 

Primero generamos un modelo con los atributos requeridos

    $ rails g model Negocio \
    > nombre:string \
    > direccion:string \
    > latitud:float \
    > longitud:float \
    > reputacion:integer \
    > tiempo_entrega:integer \
    > pedido_minimo:decimal \
    > recargo:decimal \
    > tipo:integer \
    > cobertura:integer \
    > telefono:string \
    > imagen:string \
    > activo:boolean \
    > hora_apertura:time \
    > hora_cierre:time

Con latitud y longitud usamos float porque estos son números decimales con precisión fija. No son los más exactos, pero su procesamiento es rápido. Suficiente para guardar las coordenadas de geolocalización.

En la reputación utilizamos integer porque este será un número entero (330 puntos)

El tiempo de entrega también es de tipo integer y almacena el número máximo de minutos que se demora un pedido en ser entregado.

El pedido mínimo y el recargo son de tipo decimal porque este valor está relacionado con dinero, por lo que se requiere exactitud. Para el caso particular podemos especificar que se trate de un decimal con ninguna cifra después de la coma.

El tipo es integer porque vamos a utilizar este campo como un atributo [enum](http://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html)

La cobertura también es un entero porque hace referencia a la distancia máxima en metros para la entrega de pedidos del negocio.

El telefono es de tipo string porque los números telefónicos son [cadenas de dígitos](http://stackoverflow.com/questions/23637057/why-is-it-best-to-store-a-telephone-number-as-a-string-vs-integer)

La imagen también es de tipo string porque almacena identificadores o rutas al archivo imagen.

Activo es de tipo boolean y las horas de cierre y apertura son de tipo Time ya que solo almacenan horas, minutos y segundos. - [SO](http://stackoverflow.com/questions/11889048/is-there-documentation-for-the-rails-column-types).

Al generar el modelo obtenemos los siguientes archivos:

    db/migrate/20150901165608_create_negocios.rb
    app/models/negocio.rb
    spec/models/negocio_spec.rb
    spec/factories/negocios.rb

En ellos vamos a terminar de configurar nuestro modelo.

Primero establecemos los valores para el atributo tipo en `app/models/negocio.rb`

    # Tipo
    enum tipo: [:tienda, :drogueria, :papeleria]    

### Asociaciones

El modelo Negocio va a estar asociado por una relación muchos-a-muchos con el modelo Usuario.

En Rails este tipo de asociaciones se pueden declarar de dos maneras: con `has_and_belongs_to_many` y con `has_many :through`. Como en esta ocasión no vamos a agregarle atributos a la relación utilizamos `has_and_belongs_to_many`.

Si necesitáramos realizar validaciones sobre el modelo de la relación o agregarle atributos, tendríamos que utilizar `has_many :trough` - [Rails Guides](http://guides.rubyonrails.org/association_basics.html#choosing-between-has-many-through-and-has-and-belongs-to-many). 

Declaramos las asociaciones en los modelos Usuario y Negocio.

Cuando se crea una asociación Rails asume que el modelo de la asociación corresponde al nombre de la asociación, y que la llave foránea en cualquier relación `belongs_to` será `nombredelaasociacion_id` - [Odin Project](http://www.theodinproject.com/ruby-on-rails/active-record-associations). Como vamos a declarar las asociaciones con un nombre diferente al de los modelos para leer mejor el código, tenemos que indicar a qué modelo hacemos referencia, la tabla de unión que vamos a utilizar y las llaves foráneas.

En `app/models/negocio.rb`:

    has_and_belongs_to_many :propietarios,
     class_name: 'Usuario',
     join_table: 'negocios_propios_propietarios',
     foreign_key: 'negocio_propio_id',
     association_foreign_key: 'propietario_id',
     after_add: :actualizar_propietario,
     after_remove: :actualizar_propietario      

y en `app/models/usuario.rb`

    has_and_belongs_to_many :negocios_propios,
     class_name: 'Negocio',
     join_table: 'negocios_propios_propietarios',
     foreign_key: 'propietario_id',
     association_foreign_key: 'negocio_propio_id'

Como estamos usando una relación llamada `negocio_propio` tenemos que especificar su regla de pluralización en `config/environment.rb` para que los nombres de los elementos se generen de forma correcta.

    inflect.irregular 'negocio_propio', 'negocios_propios'
    inflect.irregular 'NegocioPropio', 'NegociosPropios'

La asociación `has_and_belongs_to_many` necesita una tabla de unión en la base de datos, por lo que debemos generar una migración para crearla [rails guides](http://guides.rubyonrails.org/association_basics.html#updating-the-schema).

    $ rails g migration CreateJoinTable propietarios negocios_propios

El nombre de esta tabla se forma al unir los nombres de los elementos teniendo en cuenta el orden léxico de las palabras. Esta tabla se llamará `negocios_propios_propietarios` porque `"negocios_propios" < "propietarios" == true`

Editamos el archivo generado:

    class CreateJoinTable < ActiveRecord::Migration
      def change
        create_join_table :propietarios, :negocios_propios do |t|
          t.integer :propietario_id
          t.integer :negocios_propio_id

          t.index :negocios_propio_id
          t.index :propietario_id
          t.index [:propietario_id, :negocio_propio_id], unique: true, name: 'by_negocio_propietario'
        end
      end
    end

En el índice múltiple especificamos un nombre porque el nombre generado por rails es muy largo.

### Migración

A continuación revisamos la migración del modelo Negocio y agregamos las restricciones o los valores por defecto de las columnas según se requiera

    class CreateNegocios < ActiveRecord::Migration
      def change
        create_table :negocios do |t|
          t.string :nombre, null: false
          t.string :direccion, null: false
          t.float :latitud, null: false
          t.float :longitud, null: false
          t.integer :reputacion, default: 0
          t.integer :tiempo_entrega, default: 15
          t.decimal :pedido_minimo, default: 0
          t.decimal :recargo, default: 0
          t.integer :tipo, default: 0
          t.integer :cobertura, null: false
          t.string :telefono, null: false
          t.string :imagen
          t.boolean :activo, default: false
          t.time :hora_apertura, null: false
          t.time :hora_cierre, null: false

          t.timestamps null: false
        end
      end
    end

Luego aplicamos las migraciones generadas.

    $ rake db:migrate

Luego de aplicar la migración podemos revisar en la consola los métodos que obtenemos por declarar las relaciones entre los recursos

    > # Crear Negocio
    > n = Negocio.new
    > n.nombre = "Primera Tienda"
    > n.direccion = "calle 3 2 1"
    > n.latitud = 3
    > n.longitud = 2
    > n.cobertura = 1000
    > n.telefono = 3334433
    > n.hora_apertura = Time.now
    n.hora_cierre = Time.now + 8.hours
    > n.save

    > # Asignar Propietarios
    > n.propietarios << Usuario.first
    > n.propietarios << Usuario.last
    > n.propietarios.count

    > # Quitar propietarios
    > n.propietarios.destroy(Usuario.first)
    > n.propietarios.count

    > # Propietarios
    > u = Usuario.last
    > u.negocios_propios.first == n
    >  u.negocio_propio_ids

### Diagrama Entidad Relación

Para tener una perspectiva gráfica de las relaciones entre los recursos del sistema, generamos un diagrama entidad relación.

    $ rake erd

### TDD - Test Unitarios

Antes de escribir los tests creamos las factories de negocios en `spec/factories/negocios.rb`.

Luego implementamos los test del modelo en `spec/models/negocio_spec.rb` teniendo en cuenta la lógica del negocio y la integridad de la información

#### Validaciones

Agregamos al modelo las validaciones requeridas para pasar los test unitarios.

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

#### Callbacks

Se requiere que se actualice el atributo `es_propietario` del usuario dependiendo de si tiene o no negocios propios, para esto creamos un callback llamado `actualizar_propietario` y lo llamamos antes de crear una asociación y después de quitarla (hay unos métodos que no llaman los callbacks, como collection.clear).

    after_add: :actualizar_propietario,
    after_remove: :actualizar_propietario

    def actualizar_propietario(propietario)
      propietario.es_propietario = !propietario.negocios_propios.empty?
      propietario.save
    end

Cuando se llama el callback Rails pasa el objeto que se agrega o se quita - [Rails Guides](http://guides.rubyonrails.org/association_basics.html#has-and-belongs-to-many-association-reference).

Como no queremos que exista ningún negocio sin un propietario, agregamos un callback a la clase Usuario para que antes de eliminar el usuario se verifique que no va a quedar ningún negocio sin propietario.

    before_destroy :que_no_sea_propietario_unico

    def que_no_sea_propietario_unico
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
