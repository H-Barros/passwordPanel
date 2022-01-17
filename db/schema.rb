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

ActiveRecord::Schema.define(version: 2022_01_13_234829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "password_panel_dbs", force: :cascade do |t|
    t.string "numero"
    t.boolean "preferencial", default: false
    t.string "setor"
    t.string "servico"
    t.string "atendente"
    t.boolean "cancelado", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "inicio_atendimento"
    t.datetime "final_atendimento"
  end

end
