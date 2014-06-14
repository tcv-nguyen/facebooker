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

ActiveRecord::Schema.define(version: 20140613032000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "blocks", force: true do |t|
    t.integer  "response_id"
    t.integer  "parent_id"
    t.integer  "page_number"
    t.hstore   "content"
    t.hstore   "parent_object"
    t.hstore   "next_page_params"
    t.string   "status"
    t.string   "block_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blocks", ["parent_id"], name: "index_blocks_on_parent_id", using: :btree
  add_index "blocks", ["response_id"], name: "index_blocks_on_response_id", using: :btree
  add_index "blocks", ["status"], name: "index_blocks_on_status", using: :btree

  create_table "logs", force: true do |t|
    t.integer  "query_id"
    t.text     "message"
    t.hstore   "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "queries", force: true do |t|
    t.text     "url"
    t.string   "status"
    t.string   "query_type"
    t.hstore   "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "queries", ["query_type"], name: "index_queries_on_query_type", using: :btree
  add_index "queries", ["status"], name: "index_queries_on_status", using: :btree

  create_table "responses", force: true do |t|
    t.integer  "query_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["query_id"], name: "index_responses_on_query_id", using: :btree
  add_index "responses", ["status"], name: "index_responses_on_status", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "block_id"
    t.text     "url"
    t.hstore   "params"
    t.hstore   "message"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
