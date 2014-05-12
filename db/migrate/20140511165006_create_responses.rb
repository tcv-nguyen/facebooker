class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :query_id
      t.string  :status

      t.timestamps
    end

    add_index :responses, :query_id
    add_index :responses, :status
  end
end
