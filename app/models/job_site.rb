class JobSite < ActiveRecord::Base
  attr_accessible :name, :location, :developer_id, :user_id, :supplier_id

  belongs_to :developer
  belongs_to :user
  belongs_to :supplier

  has_many :phases, dependent: :destroy

  def purchased
  	total_purchased = 0
    phases.each do |phase|
      total_purchased += phase.purchased
    end

    return total_purchased
  end

  def total_budget
    budget = 0
    phases.each do |phase|
      budget += phase.total_budget
    end

    return budget
  end
end