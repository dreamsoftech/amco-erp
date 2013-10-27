class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
    	t.references :product
    	t.references :purchase_order
    	t.references :lot
    	t.references :location
    	t.integer :quantity

      t.timestamps
    end
  end
end