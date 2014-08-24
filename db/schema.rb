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

ActiveRecord::Schema.define(version: 20140823142201) do

  create_table "admins", force: true do |t|
    t.string "name"
    t.string "password_digest"
  end

  create_table "advertisements", force: true do |t|
    t.string  "name"
    t.integer "price"
    t.string  "city"
    t.string  "address"
    t.integer "client_id"
    t.date    "date"
    t.time    "start_hour"
    t.time    "end_hour"
    t.text    "description"
    t.integer "state"
    t.integer "service_id"
    t.integer "worker_id"
  end

  add_index "advertisements", ["client_id"], name: "index_advertisements_on_client_id"
  add_index "advertisements", ["service_id"], name: "index_advertisements_on_service_id"

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "photo"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.integer  "state"
    t.string   "confirmation_token"
    t.integer  "credits"
    t.datetime "confirmation_token_sent_at"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
  end

  create_table "reviews", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "author_id"
    t.integer "client_id"
  end

  add_index "reviews", ["client_id"], name: "index_reviews_on_client_id"

  create_table "services", force: true do |t|
    t.string "name"
  end

  create_table "workers", force: true do |t|
    t.string  "name"
    t.integer "price"
    t.string  "city"
    t.string  "address"
    t.text    "description"
    t.integer "client_id"
    t.integer "state"
    t.integer "service_id"
  end

  add_index "workers", ["client_id"], name: "index_workers_on_client_id"
  add_index "workers", ["service_id"], name: "index_workers_on_service_id"

end
