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

ActiveRecord::Schema.define(version: 20150624141847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lockers", force: :cascade do |t|
    t.boolean  "occupied",   default: false
    t.integer  "row"
    t.integer  "column"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "large"
  end

  create_table "rentals", force: :cascade do |t|
    t.boolean  "current",            default: true
    t.integer  "locker_id"
    t.integer  "creation_device_id"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "hashed_id"
    t.boolean  "terms"
    t.datetime "end_time"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

end
