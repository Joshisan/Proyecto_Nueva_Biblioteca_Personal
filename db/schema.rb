# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_20_080714) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categorias", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_categorias_on_nombre", unique: true
  end

  create_table "lecturas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "estado", default: "pendiente", null: false
    t.date "fecha_finalizacion"
    t.date "fecha_inicio"
    t.bigint "libro_id", null: false
    t.text "notas"
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["libro_id"], name: "index_lecturas_on_libro_id"
    t.index ["usuario_id", "libro_id"], name: "index_lecturas_on_usuario_id_and_libro_id", unique: true
    t.index ["usuario_id"], name: "index_lecturas_on_usuario_id"
  end

  create_table "libros", force: :cascade do |t|
    t.boolean "activo", default: true, null: false
    t.integer "anio_edicion"
    t.integer "anio_publicacion"
    t.string "autor", null: false
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.string "editorial"
    t.string "idioma"
    t.string "isbn"
    t.string "portada_url"
    t.string "titulo", null: false
    t.integer "unidades", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_libros_on_categoria_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.boolean "activo", default: true, null: false
    t.string "apellido", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "nombre", null: false
    t.string "password_digest", null: false
    t.string "rol", default: "usuario", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
  end

  add_foreign_key "lecturas", "libros"
  add_foreign_key "lecturas", "usuarios"
  add_foreign_key "libros", "categorias"
end
