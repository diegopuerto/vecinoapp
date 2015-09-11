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

ActiveRecord::Schema.define(version: 20150908192850) do

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
