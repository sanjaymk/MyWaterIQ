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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130513025623) do

  create_table "meter_readings", :force => true do |t|
    t.string   "usage_number"
    t.string   "corrected_amt"
    t.string   "remote_id"
    t.string   "meter_reading"
    t.string   "leak_status"
    t.datetime "read_date"
    t.string   "address"
    t.string   "ocr_street_addr"
    t.string   "receiver_id"
    t.string   "service_type"
    t.string   "equipment_class"
    t.string   "meter_size"
    t.string   "route_id"
    t.string   "large_amt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
