class LineItem < ActiveRecord::Base
  attr_accessible :product_id, :quantity

  belongs_to :purchase_order
  belongs_to :product
  belongs_to :lot
  belongs_to :location
end
