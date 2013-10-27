class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
    	t.references :phase
    	t.decimal		 :total_amount
    	t.string		 :note
    	
      t.timestamps
    end
  end
end
