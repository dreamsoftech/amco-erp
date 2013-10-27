class PurchaseOrder < ActiveRecord::Base
  attr_accessible :phase_id, :note, :total_amount

  belongs_to :phase
  has_many :line_items, dependent: :destroy
end