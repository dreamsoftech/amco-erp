class Location < ActiveRecord::Base
  attr_accessible :name

  belongs_to :supplier
  has_many :line_items
end
