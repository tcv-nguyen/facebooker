class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :block_id
      t.text    :url
      t.hstore  :params
      t.hstore  :message
      t.string  :status

      t.timestamps
    end
  end
end
