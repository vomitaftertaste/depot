class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def decrement_quantity
    self[:quantity] = quantity - 1
    if quantity == 0
      delete
    else
      save
    end
  end
end
