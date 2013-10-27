class Lot < ActiveRecord::Base
  attr_accessible :name, :budget, :phase_id

  belongs_to :phase
  has_many :line_items

  def left_budget_percent
  	return left_budget / budget * 100
  end

  def left_budget
    return budget - purchased
  end

  def purchased
    line_items = self.line_items
    total_purchased = 0
    line_items.each do |line_item|
      total_purchased += line_item.product.price * line_item.quantity
    end
    return total_purchased
  end
end