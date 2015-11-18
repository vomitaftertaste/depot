class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  has_many :line_items, dependent: :destroy
  validates :name, :address, :email, presence: true

  def self.payment_types
    payment_types = []
    PaymentType.all.each do |payment_type|
      payment_types << payment_type.pay_type
    end
    payment_types
  end

  validates :pay_type, inclusion: self.payment_types

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end


end
