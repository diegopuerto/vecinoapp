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



Editamos el `Gemfile` y corremos el comando `bundle update` para que el API quede actualizado y con las gemas básicas para su funcionamiento.

    ## Gemfile
    source 'https://rubygems.org'

    ruby '2.2.0'

    gem 'rails', '4.2.3'
    gem 'rails-api', '0.4.0'

    group :development, :test do
      gem 'spring', '1.3.6'
      gem 'sqlite3', '1.3.10'
    end

A medida que se vayan agregando funcionalidades se irán instalando las gemas requeridas.
