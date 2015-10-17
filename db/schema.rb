# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151014215831) do

  create_table "categorias", force: :cascade do |t|
    t.string   "nombre",     null: false
    t.string   "imagen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorias_productos", force: :cascade do |t|
    t.integer  "producto_id"
    t.integer  "categoria_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "categorias_productos", ["categoria_id", "producto_id"], name: "index_categorias_productos_on_categoria_id_and_producto_id", unique: true
  add_index "categorias_productos", ["categoria_id"], name: "index_categorias_productos_on_categoria_id"
  add_index "categorias_productos", ["producto_id"], name: "index_categorias_productos_on_producto_id"

  create_table "direcciones", force: :cascade do |t|
    t.string   "nombre",     null: false
    t.float    "lat",        null: false
    t.float    "long",       null: false
    t.string   "texto",      null: false
    t.text     "detalles"
    t.integer  "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "direcciones", ["usuario_id"], name: "index_direcciones_on_usuario_id"

  create_table "negocios", force: :cascade do |t|
    t.string   "nombre",                         null: false
    t.string   "direccion",                      null: false
    t.float    "latitud",                        null: false
    t.float    "longitud",                       null: false
    t.integer  "reputacion",     default: 0
    t.integer  "tiempo_entrega", default: 15
    t.decimal  "pedido_minimo",  default: 0.0
    t.decimal  "recargo",        default: 0.0
    t.integer  "tipo",           default: 0
    t.integer  "cobertura",                      null: false
    t.string   "telefono",                       null: false
    t.string   "imagen"
    t.boolean  "activo",         default: false
    t.time     "hora_apertura",                  null: false
    t.time     "hora_cierre",                    null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "negocios_productos", force: :cascade do |t|
    t.integer  "negocio_id"
    t.integer  "producto_id"
    t.string   "precio"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "negocios_productos", ["negocio_id", "producto_id"], name: "index_negocios_productos_on_negocio_id_and_producto_id", unique: true
  add_index "negocios_productos", ["negocio_id"], name: "index_negocios_productos_on_negocio_id"
  add_index "negocios_productos", ["producto_id"], name: "index_negocios_productos_on_producto_id"

  create_table "pedidos", force: :cascade do |t|
    t.integer  "propina"
    t.text     "comentario"
    t.integer  "total",                    null: false
    t.integer  "estado",       default: 0
    t.integer  "medio_pago",   default: 0
    t.integer  "negocio_id"
    t.integer  "usuario_id"
    t.integer  "direccion_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "pedidos", ["direccion_id"], name: "index_pedidos_on_direccion_id"
  add_index "pedidos", ["negocio_id"], name: "index_pedidos_on_negocio_id"
  add_index "pedidos", ["usuario_id"], name: "index_pedidos_on_usuario_id"

  create_table "pedidos_productos", force: :cascade do |t|
    t.integer  "pedido_id"
    t.integer  "producto_id"
    t.integer  "cantidad"
    t.integer  "precio"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pedidos_productos", ["pedido_id"], name: "index_pedidos_productos_on_pedido_id"
  add_index "pedidos_productos", ["producto_id"], name: "index_pedidos_productos_on_producto_id"

  create_table "productos", force: :cascade do |t|
    t.string   "nombre",        null: false
    t.string   "diferenciador"
    t.string   "marca",         null: false
    t.string   "presentacion",  null: false
    t.decimal  "precio"
    t.string   "imagen",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "propietarios_negocios", force: :cascade do |t|
    t.integer  "usuario_id"
    t.integer  "negocio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "propietarios_negocios", ["negocio_id"], name: "index_propietarios_negocios_on_negocio_id"
  add_index "propietarios_negocios", ["usuario_id", "negocio_id"], name: "index_propietarios_negocios_on_usuario_id_and_negocio_id", unique: true
  add_index "propietarios_negocios", ["usuario_id"], name: "index_propietarios_negocios_on_usuario_id"

  create_table "usuarios", force: :cascade do |t|
    t.string   "provider",                                  null: false
    t.string   "uid",                    default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "nickname",               default: "vecino"
    t.string   "image"
    t.string   "email"
    t.string   "telefono"
    t.boolean  "es_admin",               default: false,    null: false
    t.boolean  "es_propietario",         default: false,    null: false
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usuarios", ["email"], name: "index_usuarios_on_email"
  add_index "usuarios", ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  add_index "usuarios", ["uid", "provider"], name: "index_usuarios_on_uid_and_provider", unique: true

end
