class AddQueryIdToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :query_id, :integer

    add_index :transactions, :query_id
  end
end
