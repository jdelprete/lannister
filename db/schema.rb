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

ActiveRecord::Schema.define(version: 20171009195020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aliexpress_orders", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "aliexpress_shop_id"
    t.bigint "ali_order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tracking_code"
    t.string "tracking_company"
    t.index ["aliexpress_shop_id"], name: "index_aliexpress_orders_on_aliexpress_shop_id"
    t.index ["order_id"], name: "index_aliexpress_orders_on_order_id"
  end

  create_table "aliexpress_shops", force: :cascade do |t|
    t.bigint "ali_store_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_images_on_product_id"
  end

  create_table "indirect_variants", force: :cascade do |t|
    t.bigint "product_variant_id"
    t.bigint "product_id"
    t.bigint "shopify_id"
    t.string "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_indirect_variants_on_product_id"
    t.index ["product_variant_id"], name: "index_indirect_variants_on_product_variant_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "product_variant_id"
    t.integer "quantity"
    t.float "price"
    t.string "variant_title"
    t.boolean "has_shipped", default: false
    t.bigint "aliexpress_order_id"
    t.bigint "shopify_id"
    t.index ["aliexpress_order_id"], name: "index_line_items_on_aliexpress_order_id"
    t.index ["product_variant_id"], name: "index_line_items_on_product_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "shopify_id"
    t.integer "shopify_order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "ordered_at"
    t.text "shipping_address"
    t.string "currency"
    t.string "shopify_name"
    t.bigint "user_id"
    t.boolean "is_paid"
    t.float "total_price", default: 0.0
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.float "cost"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inventory"
    t.bigint "image_id"
    t.bigint "shopify_id"
    t.index ["image_id"], name: "index_product_variants_on_image_id"
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "product_variants_variant_options", id: false, force: :cascade do |t|
    t.integer "product_variant_id"
    t.integer "variant_option_id"
    t.index ["product_variant_id"], name: "index_product_variants_variant_options_on_product_variant_id"
    t.index ["variant_option_id"], name: "index_product_variants_variant_options_on_variant_option_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_image_id"
    t.bigint "shopify_id"
    t.bigint "aliexpress_shop_id"
    t.bigint "user_id"
    t.index ["aliexpress_shop_id"], name: "index_products_on_aliexpress_shop_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shopify_store_name"
    t.string "api_key"
    t.string "api_password"
    t.string "shared_secret"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variant_options", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.integer "ali_sku_prop"
    t.integer "ali_sku"
    t.index ["product_id"], name: "index_variant_options_on_product_id"
  end

  add_foreign_key "images", "products"
  add_foreign_key "line_items", "aliexpress_orders"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "aliexpress_shops"
  add_foreign_key "products", "images", column: "primary_image_id"
  add_foreign_key "products", "users"
  add_foreign_key "variant_options", "products"
end
