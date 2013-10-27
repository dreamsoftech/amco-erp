class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
    	t.string :name
    	t.string :email
    	t.string :phone
    	t.string :fax

      t.timestamps
    end

  end
end