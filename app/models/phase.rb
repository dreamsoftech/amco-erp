class Phase < ActiveRecord::Base
  attr_accessible :name

  belongs_to :job_site
  has_many :lots, dependent: :destroy
  has_many :purchase_orders, dependent: :destroy

  def left_budget_percent
  	if lots.count == 0
  		return 100 
  	else
  		return 100 * left_budget / total_budget
  	end
  end

  def left_budget
    total_left_budget = 0
    lots.each do |lot|
      total_left_budget += lot.left_budget
    end
    return total_left_budget
  end

  def purchased
    total_purchased = 0
    lots.each do |lot|
      total_purchased += lot.purchased
    end

    return total_purchased
  end

  def total_budget
    budget = 0
    lots.each do |lot|
      budget += lot.budget
    end

    return budget
  end
end