class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.uuid :uuid, null: false, index: { unique: true }, default: 'gen_random_uuid()'
      t.string :email, null: false, index: { unique: true }
      t.string :encrypted_password, null: false
      t.string :nickname, null: false, unique: true
      t.string :type, null: false, default: 'User'
      t.integer :level, null: false, default: 0
      t.integer :experience, null: false, default: 0

      t.timestamps
    end
  end
end
