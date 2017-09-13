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

ActiveRecord::Schema.define(version: 20170913003239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.float "cost"
    t.bigint "product_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inventory"
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "product_variants_variant_options", id: false, force: :cascade do |t|
    t.integer "product_variant_id"
    t.integer "variant_option_id"
    t.index ["product_variant_id"], name: "index_product_variants_variant_options_on_product_variant_id"
    t.index ["variant_option_id"], name: "index_product_variants_variant_options_on_variant_option_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_image_id"
  end

  create_table "variant_options", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.integer "sku_prop"
    t.integer "sku"
    t.index ["product_id"], name: "index_variant_options_on_product_id"
  end

  add_foreign_key "products", "images", column: "primary_image_id"
  add_foreign_key "variant_options", "products"
end
