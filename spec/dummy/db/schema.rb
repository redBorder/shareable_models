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

ActiveRecord::Schema.define(version: 20150831110900) do

  create_table "resources", force: :cascade do |t|
    t.string  "name"
    t.integer "user_id"
  end

  add_index "resources", ["user_id"], name: "index_resources_on_user_id"

  create_table "share_models", force: :cascade do |t|
    t.integer "resource_id"
    t.string  "resource_type"
    t.integer "shared_to_id"
    t.string  "shared_to_type"
    t.integer "shared_from_id"
    t.string  "shared_from_type"
    t.boolean "edit"
  end

  add_index "share_models", ["resource_type", "resource_id"], name: "index_share_models_on_resource_type_and_resource_id"
  add_index "share_models", ["shared_from_type", "shared_from_id"], name: "index_share_models_on_shared_from_type_and_shared_from_id"
  add_index "share_models", ["shared_to_type", "shared_to_id"], name: "index_share_models_on_shared_to_type_and_shared_to_id"

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

end
