# db/migrate/[timestamp]_create_user_searches.rb
class CreateUserSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :user_searches do |t|
      t.string :user_ip, null: false
      t.text :final_query, null: false
      t.integer :search_count, default: 1

      t.timestamps
    end

    add_index :user_searches, [:user_ip, :final_query], unique: true
    add_index :user_searches, :user_ip
  end
end
