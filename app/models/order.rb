class Order < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  
  before_validation :set_total!
  
  has_many :placements
  has_many :products, through: :placements
  
  def set_total!
  	self.total = products.map(&:price).sum
  end
  
  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
  	product_ids_and_quantities.each do |product_id_and_quantity|
  		id, quantity = product_id_and_quantity
  		
  		self.placements.build(product_id: id)
  	end
  end
end
