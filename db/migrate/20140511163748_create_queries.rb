class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text    :url
      t.string  :status, :query_type
      t.hstore  :params

      t.timestamps
    end

    add_index :queries, :status
    add_index :queries, :query_type
  end
end
