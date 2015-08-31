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

ActiveRecord::Schema.define(version: 20150401173805) do

  create_table "coupons", force: :cascade do |t|
    t.string   "code",              limit: 255
    t.string   "free_trial_length", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject",    limit: 255
    t.string   "body",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "stripe_id",     limit: 255
    t.float    "price",         limit: 24
    t.string   "interval",      limit: 255
    t.text     "features",      limit: 65535
    t.boolean  "highlight",     limit: 1
    t.integer  "display_order", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "plan_id",              limit: 4
    t.integer  "user_id",              limit: 4
    t.boolean  "deactivation_status",  limit: 1
    t.datetime "deactivated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "stripe_card_id",       limit: 255
    t.string   "stripe_customer_id",   limit: 255
    t.string   "stripe_charge_id",     limit: 255
    t.string   "stripe_payment_email", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "birth_date"
    t.string   "gender",                 limit: 255
    t.string   "country",                limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_foreign_key "messages", "users"
end
