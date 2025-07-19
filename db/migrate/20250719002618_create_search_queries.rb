# db/migrate/[timestamp]_create_search_queries.rb
class CreateSearchQueries < ActiveRecord::Migration[6.1]
  def change
    create_table :search_queries do |t|
      t.string :user_ip, null: false
      t.text :query_text, null: false
      t.boolean :is_complete, default: false

      t.timestamps
    end

    add_index :search_queries, :user_ip
    add_index :search_queries, :is_complete
  end
end


