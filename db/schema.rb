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

ActiveRecord::Schema[7.0].define(version: 2023_05_14_181454) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "bonuses", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "duration", default: 3, null: false
    t.integer "defense_delta", default: 0, null: false
    t.integer "offense_delta", default: 0, null: false
    t.integer "speed_delta", default: 0, null: false
    t.integer "stamina_delta", default: 0, null: false
    t.integer "health_delta", default: 0, null: false
    t.integer "morale_delta", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "affect_home_team", default: true, null: false
  end

  create_table "events", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "team_id"
    t.string "event_type", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["room_id"], name: "index_events_on_room_id"
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "game_recaps", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.text "recap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_recaps_on_game_id"
  end

  create_table "game_types", force: :cascade do |t|
    t.string "identifier", null: false
    t.bigint "user_id", null: false
    t.jsonb "game_data", default: {}
    t.jsonb "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_game_types_on_identifier"
    t.index ["user_id"], name: "index_game_types_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "home_team_id", null: false
    t.bigint "guest_team_id"
    t.bigint "game_type_id", null: false
    t.integer "home_team_score", default: 0, null: false
    t.integer "away_team_score", default: 0, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.boolean "with_bot", default: false, null: false
    t.integer "home_user_id", null: false
    t.integer "guest_user_id"
    t.index ["game_type_id"], name: "index_games_on_game_type_id"
    t.index ["guest_team_id"], name: "index_games_on_guest_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["room_id"], name: "index_games_on_room_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "game_type_id", null: false
    t.string "name", null: false
    t.integer "number", null: false
    t.string "position", null: false
    t.string "sub_position", null: false
    t.float "defense", default: 20.0, null: false
    t.float "offense", default: 20.0, null: false
    t.float "speed", default: 20.0, null: false
    t.float "stamina", default: 20.0, null: false
    t.float "health", default: 100.0, null: false
    t.float "morale", default: 20.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "power"
    t.index ["game_type_id"], name: "index_players_on_game_type_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "room_projections", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.integer "users_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_projections_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.boolean "private", default: false, null: false
    t.string "encrypted_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
  end

  create_table "strategies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "defense_delta", default: 0, null: false
    t.integer "offense_delta", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_type_id", null: false
    t.string "name", null: false
    t.boolean "completed", default: false, null: false
    t.integer "wins_count", default: 0, null: false
    t.integer "losses_count", default: 0, null: false
    t.integer "draws_count", default: 0, null: false
    t.integer "points_scored", default: 0, null: false
    t.integer "points_conceded", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_type_id"], name: "index_teams_on_game_type_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "telegram_profiles", force: :cascade do |t|
    t.string "telegram_id", null: false
    t.bigint "user_id", null: false
    t.string "chat_id", null: false
    t.string "nickname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_telegram_profiles_on_chat_id", unique: true
    t.index ["telegram_id"], name: "index_telegram_profiles_on_telegram_id", unique: true
    t.index ["user_id"], name: "index_telegram_profiles_on_user_id"
  end

  create_table "user_bonuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.bigint "bonuse_id", null: false
    t.boolean "used", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bonuse_id"], name: "index_user_bonuses_on_bonuse_id"
    t.index ["game_id"], name: "index_user_bonuses_on_game_id"
    t.index ["user_id"], name: "index_user_bonuses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "nickname", null: false
    t.string "type", default: "User", null: false
    t.integer "level", default: 0, null: false
    t.integer "experience", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "access_tokens", "users"
  add_foreign_key "events", "rooms"
  add_foreign_key "events", "teams"
  add_foreign_key "game_recaps", "games"
  add_foreign_key "game_types", "users"
  add_foreign_key "games", "game_types"
  add_foreign_key "games", "rooms"
  add_foreign_key "games", "teams", column: "guest_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "players", "game_types"
  add_foreign_key "players", "teams"
  add_foreign_key "room_projections", "rooms"
  add_foreign_key "rooms", "users", column: "owner_id"
  add_foreign_key "teams", "game_types"
  add_foreign_key "teams", "users"
  add_foreign_key "telegram_profiles", "users"
  add_foreign_key "user_bonuses", "bonuses"
  add_foreign_key "user_bonuses", "games"
  add_foreign_key "user_bonuses", "users"
end
