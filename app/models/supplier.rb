class Supplier < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :fax, :locations_attributes


  has_many :job_sites
  has_many :locations, dependent: :destroy
  has_many :supplier_products
  has_many :products, :through => :supplier_products
	
	accepts_nested_attributes_for :locations
end