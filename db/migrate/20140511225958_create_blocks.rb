class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :response_id, :parent_id, :page_number
      t.hstore  :content
      t.hstore  :parent_object
      t.hstore  :next_page_params
      t.string  :status, :block_type

      t.timestamps
    end

    add_index :blocks, :response_id
    add_index :blocks, :parent_id
    add_index :blocks, :status
  end
end
