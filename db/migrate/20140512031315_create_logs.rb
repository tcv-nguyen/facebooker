class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :query_id
      t.text    :message
      t.hstore  :params

      t.timestamps
    end
  end
end
