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

### Postman

Para verificar el funcionamiento del registro e inicio de sesión de usuarios utilizamos la aplicación [Postman](), con ella enviamos diferentes peticiones al API para crear usuarios de pruebas. Por medio de la consola validamos que los usuarios nuevos queden almacenados en la base de datos.

**Esto debe reemplazarse por tests**

### Heroku

Luego de hacer el commit nos pasamos a la rama master y hacemos merge con 01-usuarios, subimos a heroku, y como creamos un modelo nuevo, corremos las migraciones en producción

    $ heroku run rake db:migrate

## Implementa lista de Usuarios - TDD

    commit 

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
