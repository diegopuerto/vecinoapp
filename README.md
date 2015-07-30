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


Instalamos la gema `rails-erd` en el entorno de desarrollo para generar de forma automática diagramas entidad-relación a partir de los modelos utilizados por el API. Los diagramas se generan con `rake erd`. [Más info](https://github.com/voormedia/rails-erd).
